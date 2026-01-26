import {
  collection,
  doc,
  getDoc,
  getDocs,
  addDoc,
  query,
  where,
  orderBy,
  serverTimestamp,
  DocumentReference
} from 'firebase/firestore';
import { firebaseAuth, firebaseDb } from '@core/firebase/client';

// Types inspirés de `PronosticService` Dart

export type PredictionValue = 'team_a' | 'draw' | 'team_b';

export interface PronosticRecord {
  id: string;
  userRef: DocumentReference;
  matchRef: DocumentReference;
  prediction: PredictionValue;
  submittedAt: Date | null;
  status: 'pending' | 'won' | 'lost';
  userName: string;
}

export interface PronosticResult {
  data?: PronosticRecord;
  error?: string;
}

export interface PredictionStats {
  totalPredictions: number;
  teamACount: number;
  drawCount: number;
  teamBCount: number;
}

export class PronosticService {
  private static _instance: PronosticService | null = null;
  static get instance(): PronosticService {
    if (!this._instance) this._instance = new PronosticService();
    return this._instance;
  }

  private userPredictionsCache: Map<string, PronosticRecord | null> = new Map();
  private userSubmissions: Map<string, Date[]> = new Map();
  private static readonly maxSubmissionsPerMinute = 10;

  private constructor() {}

  private get currentUserId(): string | null {
    return firebaseAuth.currentUser?.uid ?? null;
  }

  private get currentUserName(): string {
    return firebaseAuth.currentUser?.displayName ?? 'Utilisateur';
  }

  private ensureAuthenticated(): string | null {
    const uid = this.currentUserId;
    return uid ?? null;
  }

  async submitPrediction(params: {
    matchId: string;
    prediction: PredictionValue;
  }): Promise<PronosticResult> {
    try {
      const uid = this.ensureAuthenticated();
      if (!uid) {
        return { error: 'Vous devez être connecté pour faire un pronostic' };
      }

      const rateLimit = this.checkRateLimit(uid);
      if (rateLimit.error) return rateLimit;

      const validation = this.validatePrediction(params.prediction);
      if (validation.error) return validation;

      const matchValidation = await this.validateMatch(params.matchId);
      if (matchValidation.error) return matchValidation;

      const existing = await this.getUserPrediction(params.matchId);
      if (existing) {
        return { error: 'Vous avez déjà fait un pronostic pour ce match' };
      }

      const userRef = doc(firebaseDb, 'users', uid);
      const matchRef = doc(firebaseDb, 'matches', params.matchId);

      const pronosticRef = await addDoc(collection(firebaseDb, 'pronostics'), {
        user_ref: userRef,
        match_ref: matchRef,
        prediction: params.prediction,
        submitted_at: serverTimestamp(),
        status: 'pending',
        user_name: this.currentUserName
      });

      const createdDoc = await getDoc(pronosticRef);
      const data = createdDoc.data() as any;

      const record: PronosticRecord = {
        id: createdDoc.id,
        userRef: data.user_ref,
        matchRef: data.match_ref,
        prediction: data.prediction,
        submittedAt: data.submitted_at?.toDate?.() ?? null,
        status: data.status,
        userName: data.user_name ?? this.currentUserName
      };

      this.userPredictionsCache.set(`${uid}_${params.matchId}`, record);
      this.recordSubmission(uid);

      return { data: record };
    } catch (e: any) {
      return { error: `Erreur lors de la soumission: ${String(e)}` };
    }
  }

  async getUserPrediction(matchId: string): Promise<PronosticRecord | null> {
    try {
      const uid = this.currentUserId;
      if (!uid) return null;

      const cacheKey = `${uid}_${matchId}`;
      if (this.userPredictionsCache.has(cacheKey)) {
        return this.userPredictionsCache.get(cacheKey) ?? null;
      }

      const qRef = query(
        collection(firebaseDb, 'pronostics'),
        where('user_ref', '==', doc(firebaseDb, 'users', uid)),
        where('match_ref', '==', doc(firebaseDb, 'matches', matchId)),
        orderBy('submitted_at', 'asc')
      );
      const snap = await getDocs(qRef);
      if (snap.empty) {
        this.userPredictionsCache.set(cacheKey, null);
        return null;
      }

      const docSnap = snap.docs[0];
      const data = docSnap.data() as any;
      const record: PronosticRecord = {
        id: docSnap.id,
        userRef: data.user_ref,
        matchRef: data.match_ref,
        prediction: data.prediction,
        submittedAt: data.submitted_at?.toDate?.() ?? null,
        status: data.status,
        userName: data.user_name ?? this.currentUserName
      };

      this.userPredictionsCache.set(cacheKey, record);
      return record;
    } catch {
      return null;
    }
  }

  async getMatchPredictionStats(matchId: string): Promise<PredictionStats> {
    try {
      const qRef = query(
        collection(firebaseDb, 'pronostics'),
        where('match_ref', '==', doc(firebaseDb, 'matches', matchId))
      );
      const snap = await getDocs(qRef);

      let teamACount = 0;
      let drawCount = 0;
      let teamBCount = 0;

      snap.docs.forEach((d) => {
        const data = d.data() as any;
        switch (data.prediction as PredictionValue) {
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
      });

      return {
        totalPredictions: snap.size,
        teamACount,
        drawCount,
        teamBCount
      };
    } catch {
      return {
        totalPredictions: 0,
        teamACount: 0,
        drawCount: 0,
        teamBCount: 0
      };
    }
  }

  private validatePrediction(prediction: PredictionValue): PronosticResult {
    const valid: PredictionValue[] = ['team_a', 'draw', 'team_b'];
    if (!valid.includes(prediction)) {
      return {
        error: `Pronostic invalide. Valeurs acceptées: ${valid.join(', ')}`
      };
    }
    return {};
  }

  private async validateMatch(matchId: string): Promise<PronosticResult> {
    try {
      const matchRef = doc(firebaseDb, 'matches', matchId);
      const snap = await getDoc(matchRef);
      if (!snap.exists()) {
        return { error: 'Match introuvable' };
      }
      const data = snap.data() as any;
      const status = (data.status as string) ?? 'scheduled';
      const startTime: Date | null = data.start_time?.toDate?.() ?? null;
      const predictionsEnabled = (data.predictions_enabled as boolean) ?? true;

      if (!predictionsEnabled) {
        return { error: 'Les pronostics sont désactivés pour ce match' };
      }

      if (status !== 'scheduled') {
        return { error: 'Les pronostics ne sont possibles que pour les matchs programmés' };
      }

      if (startTime && startTime < new Date()) {
        return { error: 'Ce match a déjà commencé. Les pronostics sont fermés.' };
      }

      return {};
    } catch (e: any) {
      return { error: `Erreur de validation du match: ${String(e)}` };
    }
  }

  private checkRateLimit(userId: string): PronosticResult {
    const now = new Date();
    const submissions = this.userSubmissions.get(userId) ?? [];
    const recent = submissions.filter(
      (date) => now.getTime() - date.getTime() < 60 * 1000
    );

    if (recent.length >= PronosticService.maxSubmissionsPerMinute) {
      return {
        error:
          'Trop de pronostics soumis. Veuillez patienter avant de soumettre un nouveau pronostic.'
      };
    }

    this.userSubmissions.set(userId, recent);
    return {};
  }

  private recordSubmission(userId: string) {
    const submissions = this.userSubmissions.get(userId) ?? [];
    submissions.push(new Date());
    this.userSubmissions.set(userId, submissions);
  }
}

