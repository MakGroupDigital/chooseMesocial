import 'package:flutter/foundation.dart';
import '/core/backend/backend.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import 'thesportsdb_api_service.dart';

/// Service pour synchroniser les matchs de l'API vers Firestore
class MatchSyncService {
  static MatchSyncService? _instance;
  static MatchSyncService get instance => _instance ??= MatchSyncService._();
  
  MatchSyncService._();
  
  bool _isSyncing = false;
  DateTime? _lastSync;
  
  /// Synchronise les matchs du jour depuis l'API vers Firestore
  Future<SyncResult> syncTodayMatches() async {
    if (_isSyncing) {
      return SyncResult.error('Synchronisation déjà en cours');
    }
    
    _isSyncing = true;
    
    try {
      debugPrint('🔄 Début de la synchronisation des matchs...');
      
      // Récupérer les matchs depuis l'API
      final apiResult = await TheSportsDbApiService.instance.getTodayMatches();
      
      if (!apiResult.isSuccess || apiResult.data == null) {
        _isSyncing = false;
        return SyncResult.error('Erreur lors de la récupération des matchs');
      }
      
      final matches = apiResult.data!;
      debugPrint('📥 ${matches.length} matchs récupérés depuis l'API');
      
      int created = 0;
      int updated = 0;
      int errors = 0;
      
      // Synchroniser chaque match
      for (final match in matches) {
        try {
          final result = await _syncMatch(match);
          if (result == SyncAction.created) {
            created++;
          } else if (result == SyncAction.updated) {
            updated++;
          }
        } catch (e) {
          debugPrint('❌ Erreur sync match ${match.id}: $e');
          errors++;
        }
      }
      
      _lastSync = DateTime.now();
      _isSyncing = false;
      
      debugPrint('✅ Synchronisation terminée: $created créés, $updated mis à jour, $errors erreurs');
      
      return SyncResult.success(
        created: created,
        updated: updated,
        errors: errors,
      );
    } catch (e) {
      _isSyncing = false;
      debugPrint('❌ Erreur synchronisation: $e');
      return SyncResult.error('Erreur: $e');
    }
  }
  
  /// Synchronise un match individuel
  Future<SyncAction> _syncMatch(MatchData match) async {
    try {
      // Chercher si le match existe déjà
      final existingMatches = await queryMatchRecordOnce(
        queryBuilder: (q) => q
            .where('external_id', isEqualTo: match.id)
            .limit(1),
      );
      
      final now = DateTime.now();
      
      if (existingMatches.isEmpty) {
        // Créer un nouveau match
        await MatchRecord.collection.add(createMatchRecordData(
          externalId: match.id,
          teamAName: match.homeTeamName,
          teamALogo: match.homeTeamLogo,
          teamBName: match.awayTeamName,
          teamBLogo: match.awayTeamLogo,
          competition: match.competition,
          startTime: match.startTime,
          status: match.status,
          scoreA: match.homeScore,
          scoreB: match.awayScore,
          matchMinute: match.minute ?? 0,
          predictionsEnabled: true,
          rewardAmount: 100.0, // Points par défaut
          createdAt: now,
          updatedAt: now,
        ));
        
        debugPrint('✅ Match créé: ${match.homeTeamName} vs ${match.awayTeamName}');
        return SyncAction.created;
      } else {
        // Mettre à jour le match existant
        final existingMatch = existingMatches.first;
        
        // Ne mettre à jour que si les données ont changé
        if (existingMatch.status != match.status ||
            existingMatch.scoreA != match.homeScore ||
            existingMatch.scoreB != match.awayScore) {
          
          await existingMatch.reference.update({
            'status': match.status,
            'score_a': match.homeScore,
            'score_b': match.awayScore,
            'match_minute': match.minute ?? 0,
            'updated_at': FieldValue.serverTimestamp(),
          });
          
          debugPrint('🔄 Match mis à jour: ${match.homeTeamName} vs ${match.awayTeamName}');
          
          // Si le match est terminé, traiter les pronostics
          if (match.status == 'finished' && existingMatch.status != 'finished') {
            await _processMatchPredictions(existingMatch.reference, match);
          }
          
          return SyncAction.updated;
        }
        
        return SyncAction.unchanged;
      }
    } catch (e) {
      debugPrint('❌ Erreur sync match: $e');
      rethrow;
    }
  }
  
  /// Traite les pronostics d'un match terminé
  Future<void> _processMatchPredictions(
    DocumentReference matchRef,
    MatchData match,
  ) async {
    try {
      debugPrint('🎯 Traitement des pronostics pour le match ${match.id}');
      
      // Récupérer tous les pronostics pour ce match
      final predictions = await queryPronosticRecordOnce(
        queryBuilder: (q) => q
            .where('match_ref', isEqualTo: matchRef)
            .where('status', isEqualTo: 'pending'),
      );
      
      if (predictions.isEmpty) {
        debugPrint('ℹ️ Aucun pronostic à traiter');
        return;
      }
      
      final result = match.getResult();
      debugPrint('📊 Résultat du match: $result');
      
      int winners = 0;
      int losers = 0;
      
      // Mettre à jour chaque pronostic
      for (final prediction in predictions) {
        final isWinner = prediction.prediction == result;
        final newStatus = isWinner ? 'won' : 'lost';
        
        await prediction.reference.update({
          'status': newStatus,
        });
        
        if (isWinner) {
          winners++;
          // Créditer le portefeuille de l'utilisateur
          await _creditUserWallet(prediction.userRef!, 100.0);
        } else {
          losers++;
        }
      }
      
      debugPrint('✅ Pronostics traités: $winners gagnants, $losers perdants');
    } catch (e) {
      debugPrint('❌ Erreur traitement pronostics: $e');
    }
  }
  
  /// Crédite le portefeuille d'un utilisateur
  Future<void> _creditUserWallet(DocumentReference userRef, double amount) async {
    try {
      // Chercher le portefeuille de l'utilisateur
      final wallets = await queryWalletRecordOnce(
        queryBuilder: (q) => q
            .where('user_ref', isEqualTo: userRef)
            .limit(1),
      );
      
      if (wallets.isEmpty) {
        // Créer un nouveau portefeuille
        await WalletRecord.collection.add(createWalletRecordData(
          userRef: userRef,
          balance: 0.0,
          points: amount.toInt(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      } else {
        // Mettre à jour le portefeuille existant
        final wallet = wallets.first;
        await wallet.reference.update({
          'points': FieldValue.increment(amount.toInt()),
          'updated_at': FieldValue.serverTimestamp(),
        });
      }
      
      // Créer une transaction
      await TransactionRecord.collection.add(createTransactionRecordData(
        userRef: userRef,
        type: 'reward',
        amount: amount,
        description: 'Récompense pour pronostic gagnant',
        status: 'completed',
        createdAt: DateTime.now(),
      ));
      
      debugPrint('💰 Portefeuille crédité: $amount points');
    } catch (e) {
      debugPrint('❌ Erreur crédit portefeuille: $e');
    }
  }
  
  /// Met à jour les scores en direct
  Future<void> updateLiveScores() async {
    try {
      // Récupérer les matchs en direct depuis Firestore
      final liveMatches = await queryMatchRecordOnce(
        queryBuilder: (q) => q.where('status', isEqualTo: 'live'),
      );
      
      if (liveMatches.isEmpty) {
        return;
      }
      
      final matchIds = liveMatches.map((m) => m.externalId).toList();
      
      // Récupérer les scores depuis l'API
      final scoresResult = await TheSportsDbApiService.instance.getLiveScores(matchIds);
      
      if (!scoresResult.isSuccess || scoresResult.data == null) {
        return;
      }
      
      // Mettre à jour chaque match
      for (final score in scoresResult.data!) {
        final match = liveMatches.firstWhere(
          (m) => m.externalId == score.matchId,
          orElse: () => liveMatches.first,
        );
        
        if (match.externalId == score.matchId) {
          await match.reference.update({
            'score_a': score.homeScore,
            'score_b': score.awayScore,
            'status': score.status,
            'match_minute': score.minute ?? 0,
            'updated_at': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      debugPrint('Erreur mise à jour scores: $e');
    }
  }
  
  /// Retourne le temps depuis la dernière synchronisation
  Duration? getTimeSinceLastSync() {
    if (_lastSync == null) return null;
    return DateTime.now().difference(_lastSync!);
  }
  
  /// Vérifie si une synchronisation est nécessaire
  bool needsSync() {
    if (_lastSync == null) return true;
    final timeSince = getTimeSinceLastSync();
    return timeSince != null && timeSince.inMinutes > 5;
  }
}

enum SyncAction {
  created,
  updated,
  unchanged,
}

class SyncResult {
  final int? created;
  final int? updated;
  final int? errors;
  final String? error;

  SyncResult.success({
    required this.created,
    required this.updated,
    required this.errors,
  }) : error = null;

  SyncResult.error(this.error)
      : created = null,
        updated = null,
        errors = null;

  bool get isSuccess => error == null;
  bool get isError => error != null;
}
