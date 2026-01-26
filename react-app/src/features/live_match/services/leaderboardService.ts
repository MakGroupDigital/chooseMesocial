import {
  collection,
  doc,
  getDocs,
  query,
  where,
  orderBy,
  DocumentReference
} from 'firebase/firestore';
import { firebaseDb } from '@core/firebase/client';

// Types inspirés de `LeaderboardService` Dart

export interface LeaderboardEntry {
  rank: number;
  userId: string;
  userName: string;
  correctPredictions: number;
  totalPredictions: number;
  successRate: number;
  totalEarnings: number;
}

export interface MatchLeaderboardEntry {
  userId: string;
  userName: string;
  prediction: string;
  submittedAt: Date;
  status: string;
  isWinner: boolean;
}

export class LeaderboardService {
  private static _instance: LeaderboardService | null = null;
  static get instance(): LeaderboardService {
    if (!this._instance) this._instance = new LeaderboardService();
    return this._instance;
  }

  private constructor() {}

  // Classement global inspiré de `getGlobalLeaderboard`
  async getGlobalLeaderboard(params?: {
    limit?: number;
    period?: 'all_time' | 'monthly' | 'weekly';
  }): Promise<LeaderboardEntry[]> {
    const limit = params?.limit ?? 50;
    const period = params?.period ?? 'all_time';

    let startDate: Date | null = null;
    const now = new Date();
    if (period === 'monthly') {
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
    } else if (period === 'weekly') {
      const diff = now.getDate() - now.getDay() + 1;
      startDate = new Date(now.getFullYear(), now.getMonth(), diff);
    }

    // récupérer les pronostics gagnants
    let baseQ = query(
      collection(firebaseDb, 'pronostics'),
      where('status', '==', 'won')
    );
    if (startDate) {
      baseQ = query(
        collection(firebaseDb, 'pronostics'),
        where('status', '==', 'won'),
        where('submitted_at', '>=', startDate)
      );
    }
    const winningSnap = await getDocs(baseQ);

    const userStats = new Map<
      string,
      {
        userId: string;
        userName: string;
        userRef: DocumentReference;
        correctPredictions: number;
        totalPredictions: number;
        totalEarnings: number;
      }
    >();

    winningSnap.docs.forEach((d) => {
      const data = d.data() as any;
      const userRef = data.user_ref as DocumentReference | undefined;
      if (!userRef) return;
      const userId = userRef.id;
      const userName = (data.user_name as string) ?? 'Utilisateur';

      if (!userStats.has(userId)) {
        userStats.set(userId, {
          userId,
          userName,
          userRef,
          correctPredictions: 0,
          totalPredictions: 0,
          totalEarnings: 0
        });
      }
      const stats = userStats.get(userId)!;
      stats.correctPredictions += 1;
    });

    // total des pronostics
    for (const [userId, stats] of userStats.entries()) {
      let totalQ = query(
        collection(firebaseDb, 'pronostics'),
        where('user_ref', '==', stats.userRef)
      );
      if (startDate) {
        totalQ = query(
          collection(firebaseDb, 'pronostics'),
          where('user_ref', '==', stats.userRef),
          where('submitted_at', '>=', startDate)
        );
      }
      const totalSnap = await getDocs(totalQ);
      stats.totalPredictions = totalSnap.size;
      stats.totalEarnings = stats.correctPredictions * 10; // même estimation que Dart
    }

    let list: LeaderboardEntry[] = Array.from(userStats.values())
      .filter((s) => s.correctPredictions > 0)
      .map((s) => ({
        rank: 0,
        userId: s.userId,
        userName: s.userName,
        correctPredictions: s.correctPredictions,
        totalPredictions: s.totalPredictions,
        successRate:
          s.totalPredictions > 0
            ? (s.correctPredictions / s.totalPredictions) * 100
            : 0,
        totalEarnings: s.totalEarnings
      }));

    list.sort((a, b) => {
      const byCorrect = b.correctPredictions - a.correctPredictions;
      if (byCorrect !== 0) return byCorrect;
      return b.successRate - a.successRate;
    });
    list = list.slice(0, limit).map((e, idx) => ({ ...e, rank: idx + 1 }));
    return list;
  }

  async getMatchLeaderboard(matchId: string): Promise<MatchLeaderboardEntry[]> {
    const matchRef = doc(firebaseDb, 'matches', matchId);
    const qRef = query(
      collection(firebaseDb, 'pronostics'),
      where('match_ref', '==', matchRef),
      orderBy('submitted_at', 'asc')
    );
    const snap = await getDocs(qRef);

    return snap.docs.map((d) => {
      const data = d.data() as any;
      return {
        userId: (data.user_ref as DocumentReference).id,
        userName: data.user_name ?? 'Utilisateur',
        prediction: data.prediction ?? '',
        submittedAt: data.submitted_at?.toDate?.() ?? new Date(),
        status: data.status ?? 'pending',
        isWinner: data.status === 'won'
      };
    });
  }
}

