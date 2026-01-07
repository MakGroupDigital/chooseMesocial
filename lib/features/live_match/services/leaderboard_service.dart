import '/core/backend/backend.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import '/core/flutter_flow/flutter_flow_util.dart';
import '/features/live_match/services/wallet_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service pour la gestion du classement et des gagnants
class LeaderboardService {
  static LeaderboardService? _instance;
  static LeaderboardService get instance => _instance ??= LeaderboardService._();
  
  LeaderboardService._();

  /// Traite les résultats d'un match et détermine les gagnants
  Future<ProcessingResult> processMatchResults({
    required String matchId,
    required String finalResult, // 'team_a', 'draw', 'team_b'
  }) async {
    try {
      // Vérifier que le match existe et est terminé
      final matchDoc = await FirebaseFirestore.instance
          .collection('matches')
          .doc(matchId)
          .get();

      if (!matchDoc.exists) {
        return ProcessingResult.error('Match introuvable');
      }

      final matchData = matchDoc.data()!;
      final status = matchData['status'] as String?;

      if (status != 'finished') {
        return ProcessingResult.error('Le match n\'est pas terminé');
      }

      // Récupérer tous les pronostics pour ce match
      final predictions = await queryPronosticRecordOnce(
        queryBuilder: (q) => q
            .where('match_ref', isEqualTo: 
                FirebaseFirestore.instance.collection('matches').doc(matchId))
            .where('status', isEqualTo: 'pending'),
      );

      if (predictions.isEmpty) {
        return ProcessingResult.success(ProcessingData(
          totalPredictions: 0,
          correctPredictions: 0,
          winnersProcessed: 0,
          rewardsDistributed: 0.0,
        ));
      }

      // Séparer les gagnants et les perdants
      final winners = <PronosticRecord>[];
      final losers = <PronosticRecord>[];

      for (final prediction in predictions) {
        if (prediction.prediction == finalResult) {
          winners.add(prediction);
        } else {
          losers.add(prediction);
        }
      }

      // Traiter les résultats en batch
      final batch = FirebaseFirestore.instance.batch();
      double totalRewardsDistributed = 0.0;

      // Récupérer le montant de récompense du match
      final rewardAmount = matchData['reward_amount'] as double? ?? 10.0;

      // Mettre à jour les statuts des pronostics
      for (final winner in winners) {
        batch.update(winner.reference, {
          'status': 'won',
        });
      }

      for (final loser in losers) {
        batch.update(loser.reference, {
          'status': 'lost',
        });
      }

      // Exécuter les mises à jour
      await batch.commit();

      // Distribuer les récompenses aux gagnants
      if (winners.isNotEmpty) {
        for (final winner in winners) {
          final rewardResult = await WalletService.instance.addReward(
            amount: rewardAmount,
            rewardType: 'correct_prediction',
            description: 'Pronostic correct - Match ${matchData['team_a_name']} vs ${matchData['team_b_name']}',
            matchRef: FirebaseFirestore.instance.collection('matches').doc(matchId),
          );

          if (rewardResult.isSuccess) {
            totalRewardsDistributed += rewardAmount;
          }
        }
      }

      // Créer un log d'audit
      await _createAuditLog(
        action: 'match_results_processed',
        details: {
          'match_id': matchId,
          'final_result': finalResult,
          'total_predictions': predictions.length,
          'winners': winners.length,
          'losers': losers.length,
          'total_rewards': totalRewardsDistributed,
        },
      );

      return ProcessingResult.success(ProcessingData(
        totalPredictions: predictions.length,
        correctPredictions: winners.length,
        winnersProcessed: winners.length,
        rewardsDistributed: totalRewardsDistributed,
      ));
    } catch (e) {
      debugPrint('Erreur traitement résultats match: $e');
      return ProcessingResult.error('Erreur lors du traitement: $e');
    }
  }

  /// Récupère le classement général des utilisateurs
  Future<List<LeaderboardEntry>> getGlobalLeaderboard({
    int limit = 50,
    String period = 'all_time', // 'all_time', 'monthly', 'weekly'
  }) async {
    try {
      DateTime? startDate;
      
      switch (period) {
        case 'monthly':
          startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
          break;
        case 'weekly':
          final now = DateTime.now();
          startDate = now.subtract(Duration(days: now.weekday - 1));
          break;
        case 'all_time':
        default:
          startDate = null;
      }

      // Récupérer les pronostics gagnants
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('pronostics')
          .where('status', isEqualTo: 'won');

      if (startDate != null) {
        query = query.where('submitted_at', isGreaterThanOrEqualTo: startDate);
      }

      final winningPredictions = await query.get();

      // Grouper par utilisateur et calculer les statistiques
      final Map<String, LeaderboardStats> userStats = {};

      for (final doc in winningPredictions.docs) {
        final data = doc.data();
        final userRef = data['user_ref'] as DocumentReference?;
        final userName = data['user_name'] as String? ?? 'Utilisateur';
        
        if (userRef == null) continue;

        final userId = userRef.id;
        
        if (!userStats.containsKey(userId)) {
          userStats[userId] = LeaderboardStats(
            userId: userId,
            userName: userName,
            userRef: userRef,
            correctPredictions: 0,
            totalPredictions: 0,
            totalEarnings: 0.0,
            successRate: 0.0,
          );
        }

        userStats[userId]!.correctPredictions++;
      }

      // Récupérer le total des pronostics pour calculer le taux de réussite
      for (final userId in userStats.keys) {
        final userRef = userStats[userId]!.userRef;
        
        Query<Map<String, dynamic>> totalQuery = FirebaseFirestore.instance
            .collection('pronostics')
            .where('user_ref', isEqualTo: userRef);

        if (startDate != null) {
          totalQuery = totalQuery.where('submitted_at', isGreaterThanOrEqualTo: startDate);
        }

        final totalPredictions = await totalQuery.get();
        userStats[userId]!.totalPredictions = totalPredictions.docs.length;
        
        if (userStats[userId]!.totalPredictions > 0) {
          userStats[userId]!.successRate = 
              (userStats[userId]!.correctPredictions / userStats[userId]!.totalPredictions) * 100;
        }

        // Récupérer les gains totaux
        final walletQuery = await FirebaseFirestore.instance
            .collection('transactions')
            .where('wallet_ref', isEqualTo: 
                FirebaseFirestore.instance.collection('wallets').doc()) // TODO: Améliorer cette requête
            .where('reward_type', isEqualTo: 'correct_prediction')
            .get();

        // Note: Cette requête pourrait être optimisée avec une structure de données différente
        // Pour l'instant, on utilise une estimation basée sur le nombre de prédictions correctes
        userStats[userId]!.totalEarnings = userStats[userId]!.correctPredictions * 10.0; // Estimation
      }

      // Convertir en liste et trier
      final leaderboard = userStats.values
          .where((stats) => stats.correctPredictions > 0)
          .map((stats) => LeaderboardEntry(
                rank: 0, // Sera défini après le tri
                userId: stats.userId,
                userName: stats.userName,
                correctPredictions: stats.correctPredictions,
                totalPredictions: stats.totalPredictions,
                successRate: stats.successRate,
                totalEarnings: stats.totalEarnings,
              ))
          .toList();

      // Trier par nombre de prédictions correctes, puis par taux de réussite
      leaderboard.sort((a, b) {
        final correctComparison = b.correctPredictions.compareTo(a.correctPredictions);
        if (correctComparison != 0) return correctComparison;
        return b.successRate.compareTo(a.successRate);
      });

      // Assigner les rangs
      for (int i = 0; i < leaderboard.length; i++) {
        leaderboard[i] = leaderboard[i].copyWith(rank: i + 1);
      }

      return leaderboard.take(limit).toList();
    } catch (e) {
      debugPrint('Erreur récupération classement: $e');
      return [];
    }
  }

  /// Récupère le classement pour un match spécifique
  Future<List<MatchLeaderboardEntry>> getMatchLeaderboard(String matchId) async {
    try {
      // Récupérer tous les pronostics pour ce match
      final predictions = await queryPronosticRecordOnce(
        queryBuilder: (q) => q
            .where('match_ref', isEqualTo: 
                FirebaseFirestore.instance.collection('matches').doc(matchId))
            .orderBy('submitted_at', descending: false),
      );

      final entries = <MatchLeaderboardEntry>[];
      
      for (final prediction in predictions) {
        entries.add(MatchLeaderboardEntry(
          userId: prediction.userRef?.id ?? '',
          userName: prediction.userName,
          prediction: prediction.prediction,
          submittedAt: prediction.submittedAt ?? DateTime.now(),
          status: prediction.status,
          isWinner: prediction.status == 'won',
        ));
      }

      return entries;
    } catch (e) {
      debugPrint('Erreur récupération classement match: $e');
      return [];
    }
  }

  /// Récupère les statistiques d'un utilisateur
  Future<UserLeaderboardStats> getUserStats(String userId) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Récupérer tous les pronostics de l'utilisateur
      final allPredictions = await queryPronosticRecordOnce(
        queryBuilder: (q) => q.where('user_ref', isEqualTo: userRef),
      );

      final wonPredictions = allPredictions.where((p) => p.status == 'won').length;
      final lostPredictions = allPredictions.where((p) => p.status == 'lost').length;
      final pendingPredictions = allPredictions.where((p) => p.status == 'pending').length;

      final successRate = allPredictions.isNotEmpty 
          ? (wonPredictions / allPredictions.length) * 100 
          : 0.0;

      // Récupérer les statistiques du mois
      final monthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
      final monthlyPredictions = allPredictions
          .where((p) => p.submittedAt != null && p.submittedAt!.isAfter(monthStart))
          .toList();

      final monthlyWins = monthlyPredictions.where((p) => p.status == 'won').length;
      final monthlySuccessRate = monthlyPredictions.isNotEmpty 
          ? (monthlyWins / monthlyPredictions.length) * 100 
          : 0.0;

      // Récupérer le rang dans le classement global
      final globalLeaderboard = await getGlobalLeaderboard();
      final userRank = globalLeaderboard.indexWhere((entry) => entry.userId == userId) + 1;

      return UserLeaderboardStats(
        userId: userId,
        totalPredictions: allPredictions.length,
        correctPredictions: wonPredictions,
        incorrectPredictions: lostPredictions,
        pendingPredictions: pendingPredictions,
        successRate: successRate,
        monthlyPredictions: monthlyPredictions.length,
        monthlyCorrect: monthlyWins,
        monthlySuccessRate: monthlySuccessRate,
        globalRank: userRank > 0 ? userRank : null,
        totalEarnings: wonPredictions * 10.0, // Estimation
      );
    } catch (e) {
      debugPrint('Erreur récupération stats utilisateur: $e');
      return UserLeaderboardStats.empty(userId);
    }
  }

  /// Récupère les matchs récents avec leurs gagnants
  Stream<List<RecentMatchResult>> getRecentMatchResults({int limit = 10}) {
    return FirebaseFirestore.instance
        .collection('matches')
        .where('status', isEqualTo: 'finished')
        .orderBy('start_time', descending: true)
        .limit(limit)
        .snapshots()
        .asyncMap((snapshot) async {
      final results = <RecentMatchResult>[];

      for (final doc in snapshot.docs) {
        final match = MatchRecord.fromSnapshot(doc);
        
        // Récupérer les gagnants pour ce match
        final winners = await queryPronosticRecordOnce(
          queryBuilder: (q) => q
              .where('match_ref', isEqualTo: doc.reference)
              .where('status', isEqualTo: 'won')
              .limit(5),
        );

        results.add(RecentMatchResult(
          match: match,
          winnersCount: winners.length,
          topWinners: winners.map((w) => w.userName).toList(),
        ));
      }

      return results;
    });
  }

  /// Crée un log d'audit
  Future<void> _createAuditLog({
    required String action,
    required Map<String, dynamic> details,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('audit_logs').add({
        'user_ref': currentUserReference,
        'action': action,
        'details': details,
        'ip_address': 'system',
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Erreur création log audit: $e');
    }
  }
}

/// Résultat du traitement des résultats d'un match
class ProcessingResult {
  final ProcessingData? data;
  final String? error;

  ProcessingResult.success(this.data) : error = null;
  ProcessingResult.error(this.error) : data = null;

  bool get isSuccess => data != null && error == null;
  bool get isError => error != null;
}

/// Données du traitement des résultats
class ProcessingData {
  final int totalPredictions;
  final int correctPredictions;
  final int winnersProcessed;
  final double rewardsDistributed;

  ProcessingData({
    required this.totalPredictions,
    required this.correctPredictions,
    required this.winnersProcessed,
    required this.rewardsDistributed,
  });
}

/// Entrée du classement général
class LeaderboardEntry {
  final int rank;
  final String userId;
  final String userName;
  final int correctPredictions;
  final int totalPredictions;
  final double successRate;
  final double totalEarnings;

  LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.userName,
    required this.correctPredictions,
    required this.totalPredictions,
    required this.successRate,
    required this.totalEarnings,
  });

  LeaderboardEntry copyWith({
    int? rank,
    String? userId,
    String? userName,
    int? correctPredictions,
    int? totalPredictions,
    double? successRate,
    double? totalEarnings,
  }) {
    return LeaderboardEntry(
      rank: rank ?? this.rank,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      correctPredictions: correctPredictions ?? this.correctPredictions,
      totalPredictions: totalPredictions ?? this.totalPredictions,
      successRate: successRate ?? this.successRate,
      totalEarnings: totalEarnings ?? this.totalEarnings,
    );
  }
}

/// Entrée du classement pour un match
class MatchLeaderboardEntry {
  final String userId;
  final String userName;
  final String prediction;
  final DateTime submittedAt;
  final String status;
  final bool isWinner;

  MatchLeaderboardEntry({
    required this.userId,
    required this.userName,
    required this.prediction,
    required this.submittedAt,
    required this.status,
    required this.isWinner,
  });
}

/// Statistiques internes pour le calcul du classement
class LeaderboardStats {
  final String userId;
  final String userName;
  final DocumentReference userRef;
  int correctPredictions;
  int totalPredictions;
  double totalEarnings;
  double successRate;

  LeaderboardStats({
    required this.userId,
    required this.userName,
    required this.userRef,
    required this.correctPredictions,
    required this.totalPredictions,
    required this.totalEarnings,
    required this.successRate,
  });
}

/// Statistiques détaillées d'un utilisateur
class UserLeaderboardStats {
  final String userId;
  final int totalPredictions;
  final int correctPredictions;
  final int incorrectPredictions;
  final int pendingPredictions;
  final double successRate;
  final int monthlyPredictions;
  final int monthlyCorrect;
  final double monthlySuccessRate;
  final int? globalRank;
  final double totalEarnings;

  UserLeaderboardStats({
    required this.userId,
    required this.totalPredictions,
    required this.correctPredictions,
    required this.incorrectPredictions,
    required this.pendingPredictions,
    required this.successRate,
    required this.monthlyPredictions,
    required this.monthlyCorrect,
    required this.monthlySuccessRate,
    required this.globalRank,
    required this.totalEarnings,
  });

  factory UserLeaderboardStats.empty(String userId) => UserLeaderboardStats(
    userId: userId,
    totalPredictions: 0,
    correctPredictions: 0,
    incorrectPredictions: 0,
    pendingPredictions: 0,
    successRate: 0.0,
    monthlyPredictions: 0,
    monthlyCorrect: 0,
    monthlySuccessRate: 0.0,
    globalRank: null,
    totalEarnings: 0.0,
  );
}

/// Résultat de match récent avec gagnants
class RecentMatchResult {
  final MatchRecord match;
  final int winnersCount;
  final List<String> topWinners;

  RecentMatchResult({
    required this.match,
    required this.winnersCount,
    required this.topWinners,
  });
}