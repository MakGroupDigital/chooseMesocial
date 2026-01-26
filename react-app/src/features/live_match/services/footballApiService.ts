import { firebaseDb } from '@core/firebase/client';
import { collection, getDocs, query, where, orderBy, Timestamp } from 'firebase/firestore';

// Types alignés avec `MatchData` et `ApiResult` côté Dart

export type MatchStatus = 'scheduled' | 'live' | 'finished' | 'postponed';

export interface MatchData {
  id: string;
  homeTeamName: string;
  homeTeamLogo: string;
  awayTeamName: string;
  awayTeamLogo: string;
  competition: string;
  startTime: Date;
  status: MatchStatus;
  homeScore: number;
  awayScore: number;
  minute?: number | null;
}

export interface MatchScore {
  matchId: string;
  homeScore: number;
  awayScore: number;
  status: MatchStatus;
  minute?: number | null;
}

export type ApiResult<T> =
  | { kind: 'success'; data: T; isFromCache: boolean }
  | { kind: 'error'; error: string }
  | { kind: 'cached'; data: T };

const realMadridLogo =
  'https://upload.wikimedia.org/wikipedia/en/thumb/5/56/Real_Madrid_CF.svg/150px-Real_Madrid_CF.svg.png';
const barcelonaLogo =
  'https://upload.wikimedia.org/wikipedia/en/thumb/4/47/FC_Barcelona_%28crest%29.svg/150px-FC_Barcelona_%28crest%29.svg.png';
const manchesterUnitedLogo =
  'https://upload.wikimedia.org/wikipedia/en/thumb/7/7a/Manchester_United_FC_crest.svg/150px-Manchester_United_FC_crest.svg.png';
const liverpoolLogo =
  'https://upload.wikimedia.org/wikipedia/en/thumb/0/0c/Liverpool_FC.svg/150px-Liverpool_FC.svg.png';

export class FootballApiService {
  private static _instance: FootballApiService | null = null;

  static get instance(): FootballApiService {
    if (!this._instance) this._instance = new FootballApiService();
    return this._instance;
  }

  private constructor() {}

  // Reproduit `getTestMatches()` en Dart
  getTestMatches(): MatchData[] {
    const now = new Date();
    return [
      {
        id: 'test_1',
        homeTeamName: 'Real Madrid',
        homeTeamLogo: realMadridLogo,
        awayTeamName: 'Barcelona',
        awayTeamLogo: barcelonaLogo,
        competition: 'La Liga',
        startTime: new Date(now.getTime() + 2 * 60 * 60 * 1000),
        status: 'scheduled',
        homeScore: 0,
        awayScore: 0,
        minute: null
      },
      {
        id: 'test_2',
        homeTeamName: 'Manchester United',
        homeTeamLogo: manchesterUnitedLogo,
        awayTeamName: 'Liverpool',
        awayTeamLogo: liverpoolLogo,
        competition: 'Premier League',
        startTime: new Date(now.getTime() - 30 * 60 * 1000),
        status: 'live',
        homeScore: 1,
        awayScore: 2,
        minute: 75
      }
    ];
  }

  // Version simplifiée : lit les matchs Firestore (collection 'matches') si dispo,
  // sinon renvoie les données de test, comme en Dart.
  async getTodayMatches(): Promise<ApiResult<MatchData[]>> {
    try {
      const today = new Date();
      const startOfDay = new Date(today.getFullYear(), today.getMonth(), today.getDate());
      const endOfDay = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);

      const matchesQuery = query(
        collection(firebaseDb, 'matches'),
        where('start_time', '>=', Timestamp.fromDate(startOfDay)),
        where('start_time', '<', Timestamp.fromDate(endOfDay)),
        orderBy('start_time', 'asc')
      );

      const snapshot = await getDocs(matchesQuery);
      if (snapshot.empty) {
        // Comme dans le Dart: fallback en données de test
        return { kind: 'success', data: this.getTestMatches(), isFromCache: true };
      }

      const matches: MatchData[] = snapshot.docs.map((doc) => {
        const data = doc.data() as any;
        const startTime = (data.start_time as Timestamp | undefined)?.toDate() ?? new Date();
        const status: MatchStatus = (data.status as MatchStatus) ?? 'scheduled';

        return {
          id: doc.id,
          homeTeamName: data.team_a_name ?? '',
          homeTeamLogo: data.team_a_logo ?? '',
          awayTeamName: data.team_b_name ?? '',
          awayTeamLogo: data.team_b_logo ?? '',
          competition: data.competition ?? '',
          startTime,
          status,
          homeScore: data.score_a ?? 0,
          awayScore: data.score_b ?? 0,
          minute: data.minute ?? null
        };
      });

      return { kind: 'success', data: matches, isFromCache: false };
    } catch (e: any) {
      // En cas d’erreur, renvoyer les données de test pour garder la même UX
      return {
        kind: 'success',
        data: this.getTestMatches(),
        isFromCache: true
      };
    }
  }

  // Version simplifiée de `getLiveScores` (peut être enrichie plus tard)
  async getLiveScores(matchIds: string[]): Promise<ApiResult<MatchScore[]>> {
    try {
      if (matchIds.length === 0) {
        return { kind: 'success', data: [], isFromCache: false };
      }

      const scores: MatchScore[] = [];
      for (const matchId of matchIds) {
        const qRef = query(
          collection(firebaseDb, 'matches'),
          where('match_ref_id', '==', matchId)
        );
        const snap = await getDocs(qRef);
        if (!snap.empty) {
          const doc = snap.docs[0];
          const data = doc.data() as any;
          scores.push({
            matchId,
            homeScore: data.score_a ?? 0,
            awayScore: data.score_b ?? 0,
            status: (data.status as MatchStatus) ?? 'scheduled',
            minute: data.minute ?? null
          });
        }
      }

      return { kind: 'success', data: scores, isFromCache: false };
    } catch (e: any) {
      return { kind: 'error', error: String(e) };
    }
  }
}

