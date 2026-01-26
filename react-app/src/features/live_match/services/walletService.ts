import {
  collection,
  doc,
  getDoc,
  getDocs,
  addDoc,
  query,
  where,
  orderBy,
  runTransaction,
  serverTimestamp,
  DocumentReference
} from 'firebase/firestore';
import { firebaseAuth, firebaseDb } from '@core/firebase/client';

// Types inspirés de `WalletService` Dart

export interface WalletRecord {
  id: string;
  userRef: DocumentReference;
  balance: number;
  points: number;
}

export interface TransactionRecord {
  id: string;
  amount: number;
  type: 'credit' | 'debit';
  rewardType?: string;
  createdAt: Date | null;
}

export interface WithdrawalRecord {
  id: string;
  amount: number;
  method: string;
  phoneNumber: string;
  status: 'pending' | 'approved' | 'rejected';
  requestedAt: Date | null;
}

export interface WalletOperationData {
  newBalance: number;
  newPoints: number;
  transactionId: string;
}

export interface WalletResult {
  data?: WalletOperationData;
  error?: string;
}

export interface WithdrawalResult {
  data?: WithdrawalRecord;
  error?: string;
}

export interface WalletStats {
  currentBalance: number;
  currentPoints: number;
  monthlyEarnings: number;
  correctPredictions: number;
  pendingWithdrawals: number;
}

export class WalletService {
  private static _instance: WalletService | null = null;
  static get instance(): WalletService {
    if (!this._instance) this._instance = new WalletService();
    return this._instance;
  }

  private cachedWallet: WalletRecord | null = null;
  private cachedUserId: string | null = null;

  private static readonly minWithdrawalAmount = 10;
  private static readonly maxWithdrawalAmount = 1000;

  private constructor() {}

  private get currentUserId(): string | null {
    return firebaseAuth.currentUser?.uid ?? null;
  }

  private ensureAuthenticated(): string | null {
    return this.currentUserId;
  }

  async getUserWallet(): Promise<WalletRecord | null> {
    const uid = this.ensureAuthenticated();
    if (!uid) return null;

    if (this.cachedWallet && this.cachedUserId === uid) {
      return this.cachedWallet;
    }

    const userRef = doc(firebaseDb, 'users', uid);
    const walletsQ = query(
      collection(firebaseDb, 'wallets'),
      where('user_ref', '==', userRef),
      orderBy('created_at', 'asc')
    );
    const snap = await getDocs(walletsQ);

    let walletDoc;
    if (!snap.empty) {
      walletDoc = snap.docs[0];
    } else {
      const createdRef = await addDoc(collection(firebaseDb, 'wallets'), {
        user_ref: userRef,
        balance: 0,
        points: 0,
        created_at: serverTimestamp(),
        updated_at: serverTimestamp()
      });
      walletDoc = await getDoc(createdRef);
    }

    const data = walletDoc.data() as any;
    const record: WalletRecord = {
      id: walletDoc.id,
      userRef: data.user_ref,
      balance: data.balance ?? 0,
      points: data.points ?? 0
    };

    this.cachedWallet = record;
    this.cachedUserId = uid;
    return record;
  }

  async addReward(params: {
    amount: number;
    rewardType: string;
    description: string;
    matchRef?: DocumentReference;
  }): Promise<WalletResult> {
    const uid = this.ensureAuthenticated();
    if (!uid) return { error: 'Utilisateur non connecté' };

    const wallet = await this.getUserWallet();
    if (!wallet) return { error: 'Impossible de récupérer le portefeuille' };

    try {
      const res = await runTransaction(firebaseDb, async (tx) => {
        const walletSnap = await tx.get(wallet.userRef.firestore.doc(`wallets/${wallet.id}`));
        if (!walletSnap.exists()) throw new Error('Portefeuille introuvable');

        const data = walletSnap.data() as any;
        const currentBalance = data.balance ?? 0;
        const currentPoints = data.points ?? 0;

        const newBalance = currentBalance + params.amount;
        const newPoints = currentPoints + Math.round(params.amount);

        tx.update(walletSnap.ref, {
          balance: newBalance,
          points: newPoints,
          updated_at: serverTimestamp()
        });

        const transactionRef = doc(collection(firebaseDb, 'transactions'));
        tx.set(transactionRef, {
          wallet_ref: walletSnap.ref,
          type: 'credit',
          amount: params.amount,
          reward_type: params.rewardType,
          description: params.description,
          match_ref: params.matchRef ?? null,
          created_at: serverTimestamp()
        });

        return {
          newBalance,
          newPoints,
          transactionId: transactionRef.id
        } as WalletOperationData;
      });

      this.cachedWallet = null;
      this.cachedUserId = null;
      return { data: res };
    } catch (e: any) {
      return { error: `Erreur lors de l'ajout de la récompense: ${String(e)}` };
    }
  }

  async requestWithdrawal(params: {
    amount: number;
    method: string;
    phoneNumber: string;
  }): Promise<WithdrawalResult> {
    const uid = this.ensureAuthenticated();
    if (!uid) return { error: 'Utilisateur non connecté' };

    const validation = this.validateWithdrawalAmount(params.amount);
    if (validation) return { error: validation };

    if (!['mobile_money', 'bank_transfer'].includes(params.method)) {
      return { error: 'Méthode de retrait non supportée' };
    }
    if (!params.phoneNumber || params.phoneNumber.length < 8) {
      return { error: 'Numéro de téléphone invalide' };
    }

    const wallet = await this.getUserWallet();
    if (!wallet) return { error: 'Impossible de récupérer le portefeuille' };

    if (wallet.balance < params.amount) {
      return {
        error: `Solde insuffisant. Solde actuel: ${wallet.balance.toFixed(2)}`
      };
    }

    const pendingQ = query(
      collection(firebaseDb, 'withdrawals'),
      where('user_ref', '==', wallet.userRef),
      where('status', '==', 'pending')
    );
    const pendingSnap = await getDocs(pendingQ);
    if (!pendingSnap.empty) {
      return { error: 'Vous avez déjà une demande de retrait en attente' };
    }

    const withdrawalRef = await addDoc(collection(firebaseDb, 'withdrawals'), {
      wallet_ref: doc(firebaseDb, 'wallets', wallet.id),
      user_ref: wallet.userRef,
      amount: params.amount,
      method: params.method,
      phone_number: params.phoneNumber,
      status: 'pending',
      requested_at: serverTimestamp()
    });

    const created = await getDoc(withdrawalRef);
    const data = created.data() as any;
    const record: WithdrawalRecord = {
      id: created.id,
      amount: data.amount ?? params.amount,
      method: data.method ?? params.method,
      phoneNumber: data.phone_number ?? params.phoneNumber,
      status: data.status ?? 'pending',
      requestedAt: data.requested_at?.toDate?.() ?? null
    };

    return { data: record };
  }

  async getWalletStats(): Promise<WalletStats> {
    const wallet = await this.getUserWallet();
    if (!wallet) {
      return {
        currentBalance: 0,
        currentPoints: 0,
        monthlyEarnings: 0,
        correctPredictions: 0,
        pendingWithdrawals: 0
      };
    }

    const monthStart = new Date(new Date().getFullYear(), new Date().getMonth(), 1);
    const txQ = query(
      collection(firebaseDb, 'transactions'),
      where('wallet_ref', '==', doc(firebaseDb, 'wallets', wallet.id)),
      where('created_at', '>=', monthStart),
      where('type', '==', 'credit')
    );
    const txSnap = await getDocs(txQ);

    let monthlyEarnings = 0;
    let correctPredictions = 0;

    txSnap.docs.forEach((d) => {
      const data = d.data() as any;
      monthlyEarnings += data.amount ?? 0;
      if (data.reward_type === 'correct_prediction') correctPredictions++;
    });

    const pendingQ = query(
      collection(firebaseDb, 'withdrawals'),
      where('user_ref', '==', wallet.userRef),
      where('status', '==', 'pending')
    );
    const pendingSnap = await getDocs(pendingQ);
    let pendingAmount = 0;
    pendingSnap.docs.forEach((d) => {
      const data = d.data() as any;
      pendingAmount += data.amount ?? 0;
    });

    return {
      currentBalance: wallet.balance,
      currentPoints: wallet.points,
      monthlyEarnings,
      correctPredictions,
      pendingWithdrawals: pendingAmount
    };
  }

  private validateWithdrawalAmount(amount: number): string | null {
    if (amount < WalletService.minWithdrawalAmount) {
      return `Montant minimum de retrait: ${WalletService.minWithdrawalAmount.toFixed(2)}`;
    }
    if (amount > WalletService.maxWithdrawalAmount) {
      return `Montant maximum de retrait: ${WalletService.maxWithdrawalAmount.toFixed(2)}`;
    }
    return null;
  }
}

