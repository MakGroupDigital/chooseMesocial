import '/core/backend/backend.dart';
import '/core/auth/firebase_auth/auth_util.dart';
import 'package:flutter/foundation.dart';

/// Service pour la gestion du portefeuille utilisateur
class WalletService {
  static WalletService? _instance;
  static WalletService get instance => _instance ??= WalletService._();
  
  WalletService._();

  // Cache du portefeuille utilisateur
  WalletRecord? _cachedWallet;
  String? _cachedUserId;

  // Seuils de retrait
  static const double _minWithdrawalAmount = 10.0; // 10€ minimum
  static const double _maxWithdrawalAmount = 1000.0; // 1000€ maximum par demande

  /// Récupère ou crée le portefeuille de l'utilisateur connecté
  Future<WalletRecord?> getUserWallet() async {
    try {
      if (!loggedIn || currentUserReference == null) return null;

      final userId = currentUserUid;

      // Vérifier le cache
      if (_cachedWallet != null && _cachedUserId == userId) {
        return _cachedWallet;
      }

      // Chercher le portefeuille existant
      final existingWallets = await queryWalletRecordOnce(
        queryBuilder: (q) => q
            .where('user_ref', isEqualTo: currentUserReference)
            .limit(1),
      );

      WalletRecord wallet;
      if (existingWallets.isNotEmpty) {
        wallet = existingWallets.first;
      } else {
        // Créer un nouveau portefeuille
        wallet = await _createWallet();
      }

      // Mettre en cache
      _cachedWallet = wallet;
      _cachedUserId = userId;

      return wallet;
    } catch (e) {
      debugPrint('Erreur récupération portefeuille: $e');
      return null;
    }
  }

  /// Crée un nouveau portefeuille pour l'utilisateur
  Future<WalletRecord> _createWallet() async {
    final walletData = createWalletRecordData(
      userRef: currentUserReference!,
      balance: 0.0,
      points: 0,
      createdAt: FieldValue.serverTimestamp() as DateTime?,
      updatedAt: FieldValue.serverTimestamp() as DateTime?,
    );

    final docRef = await FirebaseFirestore.instance
        .collection('wallets')
        .add(walletData);

    final createdDoc = await docRef.get();
    return WalletRecord.fromSnapshot(createdDoc);
  }

  /// Ajoute des points au portefeuille (récompense de pronostic)
  Future<WalletResult> addReward({
    required double amount,
    required String rewardType,
    required String description,
    DocumentReference? matchRef,
  }) async {
    try {
      if (!loggedIn || currentUserReference == null) {
        return WalletResult.error('Utilisateur non connecté');
      }

      final wallet = await getUserWallet();
      if (wallet == null) {
        return WalletResult.error('Impossible de récupérer le portefeuille');
      }

      // Utiliser une transaction Firestore pour garantir la cohérence
      final result = await FirebaseFirestore.instance.runTransaction<WalletResult>(
        (transaction) async {
          // Lire le portefeuille actuel
          final walletDoc = await transaction.get(wallet.reference);
          if (!walletDoc.exists) {
            throw Exception('Portefeuille introuvable');
          }

          final currentBalance = (walletDoc.data() as Map<String, dynamic>)['balance'] as double? ?? 0.0;
          final currentPoints = (walletDoc.data() as Map<String, dynamic>)['points'] as int? ?? 0;
          
          final newBalance = currentBalance + amount;
          final newPoints = currentPoints + amount.round();

          // Mettre à jour le portefeuille
          transaction.update(wallet.reference, {
            'balance': newBalance,
            'points': newPoints,
            'updated_at': FieldValue.serverTimestamp(),
          });

          // Créer une transaction
          final transactionData = createTransactionRecordData(
            walletRef: wallet.reference,
            type: 'credit',
            amount: amount,
            rewardType: rewardType,
            description: description,
            matchRef: matchRef,
            createdAt: FieldValue.serverTimestamp() as DateTime?,
          );

          final transactionRef = FirebaseFirestore.instance
              .collection('transactions')
              .doc();
          transaction.set(transactionRef, transactionData);

          return WalletResult.success(WalletOperationData(
            newBalance: newBalance,
            newPoints: newPoints,
            transactionId: transactionRef.id,
          ));
        },
      );

      // Invalider le cache
      _invalidateCache();

      // Créer un log d'audit
      await _createAuditLog(
        action: 'reward_added',
        details: {
          'amount': amount,
          'reward_type': rewardType,
          'description': description,
          'match_id': matchRef?.id,
        },
      );

      return result;
    } catch (e) {
      debugPrint('Erreur ajout récompense: $e');
      return WalletResult.error('Erreur lors de l\'ajout de la récompense: $e');
    }
  }

  /// Demande un retrait
  Future<WithdrawalResult> requestWithdrawal({
    required double amount,
    required String method,
    required String phoneNumber,
  }) async {
    try {
      if (!loggedIn || currentUserReference == null) {
        return WithdrawalResult.error('Utilisateur non connecté');
      }

      // Valider le montant
      final validationResult = _validateWithdrawalAmount(amount);
      if (!validationResult.isSuccess) {
        return WithdrawalResult.error(validationResult.error!);
      }

      // Valider la méthode
      if (!['mobile_money', 'bank_transfer'].contains(method)) {
        return WithdrawalResult.error('Méthode de retrait non supportée');
      }

      // Valider le numéro de téléphone
      if (phoneNumber.isEmpty || phoneNumber.length < 8) {
        return WithdrawalResult.error('Numéro de téléphone invalide');
      }

      final wallet = await getUserWallet();
      if (wallet == null) {
        return WithdrawalResult.error('Impossible de récupérer le portefeuille');
      }

      // Vérifier le solde
      if (wallet.balance < amount) {
        return WithdrawalResult.error(
          'Solde insuffisant. Solde actuel: ${wallet.balance.toStringAsFixed(2)}€'
        );
      }

      // Vérifier s'il y a déjà une demande en attente
      final pendingWithdrawals = await queryWithdrawalRecordOnce(
        queryBuilder: (q) => q
            .where('user_ref', isEqualTo: currentUserReference)
            .where('status', isEqualTo: 'pending')
            .limit(1),
      );

      if (pendingWithdrawals.isNotEmpty) {
        return WithdrawalResult.error(
          'Vous avez déjà une demande de retrait en attente'
        );
      }

      // Créer la demande de retrait
      final withdrawalData = createWithdrawalRecordData(
        walletRef: wallet.reference,
        userRef: currentUserReference!,
        amount: amount,
        method: method,
        phoneNumber: phoneNumber,
        status: 'pending',
        requestedAt: FieldValue.serverTimestamp() as DateTime?,
      );

      final docRef = await FirebaseFirestore.instance
          .collection('withdrawals')
          .add(withdrawalData);

      final createdDoc = await docRef.get();
      final withdrawal = WithdrawalRecord.fromSnapshot(createdDoc);

      // Créer un log d'audit
      await _createAuditLog(
        action: 'withdrawal_requested',
        details: {
          'amount': amount,
          'method': method,
          'withdrawal_id': docRef.id,
        },
      );

      return WithdrawalResult.success(withdrawal);
    } catch (e) {
      debugPrint('Erreur demande retrait: $e');
      return WithdrawalResult.error('Erreur lors de la demande de retrait: $e');
    }
  }

  /// Récupère l'historique des transactions
  Stream<List<TransactionRecord>> getTransactionHistory() {
    if (!loggedIn || currentUserReference == null) {
      return Stream.value([]);
    }

    return getUserWallet().asStream().asyncExpand((wallet) {
      if (wallet == null) return Stream.value([]);

      return FirebaseFirestore.instance
          .collection('transactions')
          .where('wallet_ref', isEqualTo: wallet.reference)
          .orderBy('created_at', descending: true)
          .limit(50)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => TransactionRecord.fromSnapshot(doc))
              .toList());
    });
  }

  /// Récupère l'historique des retraits
  Stream<List<WithdrawalRecord>> getWithdrawalHistory() {
    if (!loggedIn || currentUserReference == null) {
      return Stream.value([]);
    }

    return FirebaseFirestore.instance
        .collection('withdrawals')
        .where('user_ref', isEqualTo: currentUserReference)
        .orderBy('requested_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WithdrawalRecord.fromSnapshot(doc))
            .toList());
  }

  /// Récupère les statistiques du portefeuille
  Future<WalletStats> getWalletStats() async {
    try {
      final wallet = await getUserWallet();
      if (wallet == null) {
        return WalletStats.empty();
      }

      // Récupérer les transactions du mois
      final monthStart = DateTime(DateTime.now().year, DateTime.now().month, 1);
      final monthTransactions = await FirebaseFirestore.instance
          .collection('transactions')
          .where('wallet_ref', isEqualTo: wallet.reference)
          .where('created_at', isGreaterThanOrEqualTo: monthStart)
          .where('type', isEqualTo: 'credit')
          .get()
          .then((snapshot) => snapshot.docs
              .map((doc) => TransactionRecord.fromSnapshot(doc))
              .toList());

      double monthlyEarnings = 0.0;
      int correctPredictions = 0;
      Map<String, int> rewardTypes = {};

      for (final transaction in monthTransactions) {
        monthlyEarnings += transaction.amount;
        if (transaction.rewardType.isNotEmpty) {
          rewardTypes[transaction.rewardType] = 
              (rewardTypes[transaction.rewardType] ?? 0) + 1;
          if (transaction.rewardType == 'correct_prediction') {
            correctPredictions++;
          }
        }
      }

      // Récupérer les retraits en attente
      final pendingWithdrawals = await FirebaseFirestore.instance
          .collection('withdrawals')
          .where('user_ref', isEqualTo: currentUserReference)
          .where('status', isEqualTo: 'pending')
          .get()
          .then((snapshot) => snapshot.docs
              .map((doc) => WithdrawalRecord.fromSnapshot(doc))
              .toList());

      double pendingAmount = 0.0;
      for (final withdrawal in pendingWithdrawals) {
        pendingAmount += withdrawal.amount;
      }

      return WalletStats(
        currentBalance: wallet.balance,
        currentPoints: wallet.points,
        monthlyEarnings: monthlyEarnings,
        correctPredictions: correctPredictions,
        pendingWithdrawals: pendingAmount,
        rewardBreakdown: rewardTypes,
      );
    } catch (e) {
      debugPrint('Erreur statistiques portefeuille: $e');
      return WalletStats.empty();
    }
  }

  /// Valide le montant de retrait
  ValidationResult _validateWithdrawalAmount(double amount) {
    if (amount < _minWithdrawalAmount) {
      return ValidationResult.error(
        'Montant minimum de retrait: ${_minWithdrawalAmount.toStringAsFixed(2)}€'
      );
    }

    if (amount > _maxWithdrawalAmount) {
      return ValidationResult.error(
        'Montant maximum de retrait: ${_maxWithdrawalAmount.toStringAsFixed(2)}€'
      );
    }

    return ValidationResult.success();
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
        'ip_address': 'unknown',
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Erreur création log audit: $e');
    }
  }

  /// Invalide le cache
  void _invalidateCache() {
    _cachedWallet = null;
    _cachedUserId = null;
  }

  /// Nettoie le cache
  void clearCache() {
    _invalidateCache();
  }

  /// Récupère les seuils de retrait
  static double get minWithdrawalAmount => _minWithdrawalAmount;
  static double get maxWithdrawalAmount => _maxWithdrawalAmount;
}

/// Résultat d'une opération de portefeuille
class WalletResult {
  final WalletOperationData? data;
  final String? error;

  WalletResult.success(this.data) : error = null;
  WalletResult.error(this.error) : data = null;

  bool get isSuccess => data != null && error == null;
  bool get isError => error != null;
}

/// Données d'une opération de portefeuille
class WalletOperationData {
  final double newBalance;
  final int newPoints;
  final String transactionId;

  WalletOperationData({
    required this.newBalance,
    required this.newPoints,
    required this.transactionId,
  });
}

/// Résultat d'une demande de retrait
class WithdrawalResult {
  final WithdrawalRecord? data;
  final String? error;

  WithdrawalResult.success(this.data) : error = null;
  WithdrawalResult.error(this.error) : data = null;

  bool get isSuccess => data != null && error == null;
  bool get isError => error != null;
}

/// Résultat de validation
class ValidationResult {
  final String? error;

  ValidationResult.success() : error = null;
  ValidationResult.error(this.error);

  bool get isSuccess => error == null;
}

/// Statistiques du portefeuille
class WalletStats {
  final double currentBalance;
  final int currentPoints;
  final double monthlyEarnings;
  final int correctPredictions;
  final double pendingWithdrawals;
  final Map<String, int> rewardBreakdown;

  WalletStats({
    required this.currentBalance,
    required this.currentPoints,
    required this.monthlyEarnings,
    required this.correctPredictions,
    required this.pendingWithdrawals,
    required this.rewardBreakdown,
  });

  factory WalletStats.empty() => WalletStats(
    currentBalance: 0.0,
    currentPoints: 0,
    monthlyEarnings: 0.0,
    correctPredictions: 0,
    pendingWithdrawals: 0.0,
    rewardBreakdown: {},
  );

  /// Solde disponible pour retrait (balance - pending withdrawals)
  double get availableBalance => currentBalance - pendingWithdrawals;

  /// Taux de réussite des pronostics ce mois
  double get successRate {
    final totalPredictions = rewardBreakdown.values.fold(0, (sum, count) => sum + count);
    return totalPredictions > 0 ? (correctPredictions / totalPredictions) * 100 : 0.0;
  }
}