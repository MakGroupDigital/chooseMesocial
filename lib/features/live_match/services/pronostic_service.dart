import '/core/backend/backend.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service pour la gestion des pronostics utilisateurs
class PronosticService {
  static PronosticService? _instance;
  static PronosticService get instance => _instance ??= PronosticService._();
  
  PronosticService._();

  // Cache des pronostics utilisateur pour éviter les requêtes répétées
  final Map<String, PronosticRecord?> _userPredictionsCache = {};
  
  // Rate limiting - limite de 10 pronostics par minute par utilisateur
  final Map<String, List<DateTime>> _userSubmissions = {};
  static const int _maxSubmissionsPerMinute = 10;

  /// Valide et soumet un pronostic
  Future<PronosticResult> submitPrediction({
    required String matchId,
    required String prediction,
  }) async {
    try {
      // Vérifier l'authentification
      if (!loggedIn || currentUserReference == null) {
        return PronosticResult.error('Vous devez être connecté pour faire un pronostic');
      }

      final userId = currentUserUid;
      
      // Vérifier le rate limiting
      final rateLimitResult = _checkRateLimit(userId);
      if (!rateLimitResult.isSuccess) {
        return rateLimitResult;
      }

      // Valider le pronostic
      final validationResult = _validatePrediction(prediction);
      if (!validationResult.isSuccess) {
        return validationResult;
      }

      // Vérifier si le match existe et est valide pour les pronostics
      final matchValidation = await _validateMatch(matchId);
      if (!matchValidation.isSuccess) {
        return matchValidation;
      }

      // Vérifier si l'utilisateur a déjà fait un pronostic pour ce match
      final existingPrediction = await getUserPrediction(matchId);
      if (existingPrediction != null) {
        return PronosticResult.error('Vous avez déjà fait un pronostic pour ce match');
      }

      // Créer le pronostic avec horodatage serveur
      final pronosticData = createPronosticRecordData(
        userRef: currentUserReference!,
        matchRef: FirebaseFirestore.instance.collection('matches').doc(matchId),
        prediction: prediction,
        submittedAt: FieldValue.serverTimestamp() as DateTime?,
        status: 'pending',
        userName: currentUserDisplayName ?? 'Utilisateur',
      );

      // Sauvegarder dans Firestore
      final docRef = await FirebaseFirestore.instance
          .collection('pronostics')
          .add(pronosticData);

      // Récupérer le document créé pour obtenir le timestamp serveur
      final createdDoc = await docRef.get();
      final pronosticRecord = PronosticRecord.fromSnapshot(createdDoc);

      // Mettre à jour le cache
      _userPredictionsCache['${userId}_$matchId'] = pronosticRecord;

      // Enregistrer la soumission pour le rate limiting
      _recordSubmission(userId);

      // Créer un log d'audit
      await _createAuditLog(
        userId: userId,
        action: 'prediction_submitted',
        details: {
          'match_id': matchId,
          'prediction': prediction,
          'pronostic_id': docRef.id,
        },
      );

      return PronosticResult.success(pronosticRecord);
    } catch (e) {
      debugPrint('Erreur soumission pronostic: $e');
      return PronosticResult.error('Erreur lors de la soumission: $e');
    }
  }

  /// Récupère le pronostic de l'utilisateur pour un match
  Future<PronosticRecord?> getUserPrediction(String matchId) async {
    try {
      if (!loggedIn || currentUserReference == null) return null;

      final userId = currentUserUid;
      final cacheKey = '${userId}_$matchId';

      // Vérifier le cache d'abord
      if (_userPredictionsCache.containsKey(cacheKey)) {
        return _userPredictionsCache[cacheKey];
      }

      // Requête Firestore
      final querySnapshot = await queryPronosticRecordOnce(
        queryBuilder: (q) => q
            .where('user_ref', isEqualTo: currentUserReference)
            .where('match_ref', isEqualTo: 
                FirebaseFirestore.instance.collection('matches').doc(matchId))
            .limit(1),
      );

      final prediction = querySnapshot.isNotEmpty ? querySnapshot.first : null;
      
      // Mettre en cache
      _userPredictionsCache[cacheKey] = prediction;
      
      return prediction;
    } catch (e) {
      debugPrint('Erreur récupération pronostic: $e');
      return null;
    }
  }

  /// Récupère tous les pronostics d'un match (pour admin)
  Stream<List<PronosticRecord>> getMatchPredictions(String matchId) {
    return queryPronosticRecord(
      queryBuilder: (q) => q
          .where('match_ref', isEqualTo: 
              FirebaseFirestore.instance.collection('matches').doc(matchId))
          .orderBy('submitted_at', descending: false),
    );
  }

  /// Récupère l'historique des pronostics de l'utilisateur
  Stream<List<PronosticRecord>> getUserPredictions() {
    if (!loggedIn || currentUserReference == null) {
      return Stream.value([]);
    }

    return queryPronosticRecord(
      queryBuilder: (q) => q
          .where('user_ref', isEqualTo: currentUserReference)
          .orderBy('submitted_at', descending: true),
    );
  }

  /// Met à jour le statut d'un pronostic (utilisé par les Cloud Functions)
  Future<void> updatePredictionStatus({
    required String pronosticId,
    required String status,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('pronostics')
          .doc(pronosticId)
          .update({'status': status});

      // Invalider le cache pour ce pronostic
      _invalidateCache(pronosticId);
    } catch (e) {
      debugPrint('Erreur mise à jour statut pronostic: $e');
    }
  }

  /// Valide le format du pronostic
  PronosticResult _validatePrediction(String prediction) {
    const validPredictions = ['team_a', 'draw', 'team_b'];
    
    if (!validPredictions.contains(prediction)) {
      return PronosticResult.error(
        'Pronostic invalide. Valeurs acceptées: ${validPredictions.join(', ')}'
      );
    }
    
    return PronosticResult.success(null);
  }

  /// Valide qu'un match peut recevoir des pronostics
  Future<PronosticResult> _validateMatch(String matchId) async {
    try {
      // Récupérer le match depuis Firestore
      final matchDoc = await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .get();

      if (!matchDoc.exists) {
        return PronosticResult.error('Match introuvable');
      }

      final matchData = matchDoc.data()!;
      final status = matchData['status'] as String?;
      final startTime = (matchData['start_time'] as Timestamp?)?.toDate();
      final predictionsEnabled = matchData['predictions_enabled'] as bool? ?? true;

      // Vérifier si les pronostics sont activés pour ce match
      if (!predictionsEnabled) {
        return PronosticResult.error('Les pronostics sont désactivés pour ce match');
      }

      // Vérifier le statut du match
      if (status != 'scheduled') {
        return PronosticResult.error('Les pronostics ne sont possibles que pour les matchs programmés');
      }

      // Vérifier l'heure de début
      if (startTime != null && startTime.isBefore(DateTime.now())) {
        return PronosticResult.error('Ce match a déjà commencé. Les pronostics sont fermés.');
      }

      return PronosticResult.success(null);
    } catch (e) {
      return PronosticResult.error('Erreur de validation du match: $e');
    }
  }

  /// Vérifie le rate limiting
  PronosticResult _checkRateLimit(String userId) {
    final now = DateTime.now();
    final userSubmissions = _userSubmissions[userId] ?? [];
    
    // Nettoyer les soumissions anciennes (plus d'une minute)
    userSubmissions.removeWhere(
      (submission) => now.difference(submission).inMinutes >= 1
    );
    
    // Vérifier la limite
    if (userSubmissions.length >= _maxSubmissionsPerMinute) {
      return PronosticResult.error(
        'Trop de pronostics soumis. Veuillez patienter avant de soumettre un nouveau pronostic.'
      );
    }
    
    return PronosticResult.success(null);
  }

  /// Enregistre une soumission pour le rate limiting
  void _recordSubmission(String userId) {
    final submissions = _userSubmissions[userId] ?? [];
    submissions.add(DateTime.now());
    _userSubmissions[userId] = submissions;
  }

  /// Crée un log d'audit
  Future<void> _createAuditLog({
    required String userId,
    required String action,
    required Map<String, dynamic> details,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('audit_logs').add({
        'user_ref': currentUserReference,
        'action': action,
        'details': details,
        'ip_address': 'unknown', // À implémenter si nécessaire
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Erreur création log audit: $e');
    }
  }

  /// Invalide le cache pour un pronostic
  void _invalidateCache(String pronosticId) {
    _userPredictionsCache.removeWhere((key, value) => 
        value?.reference.id == pronosticId);
  }

  /// Nettoie le cache expiré
  void clearCache() {
    _userPredictionsCache.clear();
    _userSubmissions.clear();
  }

  /// Retourne les statistiques des pronostics pour un match
  Future<PredictionStats> getMatchPredictionStats(String matchId) async {
    try {
      final predictions = await queryPronosticRecordOnce(
        queryBuilder: (q) => q.where('match_ref', isEqualTo: 
            FirebaseFirestore.instance.collection('matches').doc(matchId)),
      );

      int teamACount = 0;
      int drawCount = 0;
      int teamBCount = 0;

      for (final prediction in predictions) {
        switch (prediction.prediction) {
          case 'team_a':
            teamACount++;
            break;
          case 'draw':
            drawCount++;
            break;
          case 'team_b':
            teamBCount++;
            break;
        }
      }

      return PredictionStats(
        totalPredictions: predictions.length,
        teamACount: teamACount,
        drawCount: drawCount,
        teamBCount: teamBCount,
      );
    } catch (e) {
      debugPrint('Erreur statistiques pronostics: $e');
      return PredictionStats(
        totalPredictions: 0,
        teamACount: 0,
        drawCount: 0,
        teamBCount: 0,
      );
    }
  }
}

/// Résultat d'une opération de pronostic
class PronosticResult {
  final PronosticRecord? data;
  final String? error;

  PronosticResult.success(this.data) : error = null;
  PronosticResult.error(this.error) : data = null;

  bool get isSuccess => data != null && error == null;
  bool get isError => error != null;
}

/// Statistiques des pronostics pour un match
class PredictionStats {
  final int totalPredictions;
  final int teamACount;
  final int drawCount;
  final int teamBCount;

  PredictionStats({
    required this.totalPredictions,
    required this.teamACount,
    required this.drawCount,
    required this.teamBCount,
  });

  /// Pourcentage de pronostics pour l'équipe A
  double get teamAPercentage => 
      totalPredictions > 0 ? (teamACount / totalPredictions) * 100 : 0;

  /// Pourcentage de pronostics pour le match nul
  double get drawPercentage => 
      totalPredictions > 0 ? (drawCount / totalPredictions) * 100 : 0;

  /// Pourcentage de pronostics pour l'équipe B
  double get teamBPercentage => 
      totalPredictions > 0 ? (teamBCount / totalPredictions) * 100 : 0;
}