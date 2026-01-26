import React, { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { FootballApiService, MatchData } from '../services/footballApiService';
import {
  PredictionStats,
  PronosticService,
  PronosticRecord,
  PredictionValue
} from '../services/pronosticService';

// Correspond à `match_detail_widget.dart` (détail d'un match) + intégration PronosticService.

export const MatchDetailPage: React.FC = () => {
  const { matchId } = useParams<{ matchId: string }>();
  const [match, setMatch] = useState<MatchData | null>(null);
  const [predictionStats, setPredictionStats] = useState<PredictionStats | null>(null);
  const [userPrediction, setUserPrediction] = useState<PronosticRecord | null>(null);
  const [selectedPrediction, setSelectedPrediction] = useState<PredictionValue | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  useEffect(() => {
    if (!matchId) return;
    void loadAll(matchId);
  }, [matchId]);

  async function loadAll(id: string) {
    setLoading(true);
    setError(null);

    try {
      const allMatches = await FootballApiService.instance.getTodayMatches();
      let found: MatchData | undefined;
      if (allMatches.kind === 'success' || allMatches.kind === 'cached') {
        found = allMatches.data.find((m) => m.id === id);
      }

      if (!found) {
        setError('Match introuvable');
      } else {
        setMatch(found);
      }

      const [stats, userPred] = await Promise.all([
        PronosticService.instance.getMatchPredictionStats(id),
        PronosticService.instance.getUserPrediction(id)
      ]);

      setPredictionStats(stats);
      setUserPrediction(userPred);
      if (userPred) setSelectedPrediction(userPred.prediction);
    } catch (e: any) {
      setError(String(e));
    } finally {
      setLoading(false);
    }
  }

  const canPredict =
    match && match.status === 'scheduled' && (!userPrediction || userPrediction.status === 'pending');

  async function handleSubmit() {
    if (!matchId || !selectedPrediction || !canPredict) return;
    setSubmitting(true);
    setError(null);
    setSuccessMessage(null);

    const result = await PronosticService.instance.submitPrediction({
      matchId,
      prediction: selectedPrediction
    });

    if (result.error) {
      setError(result.error);
    } else if (result.data) {
      setUserPrediction(result.data);
      setSuccessMessage('Votre pronostic a été enregistré avec succès.');
      const stats = await PronosticService.instance.getMatchPredictionStats(matchId);
      setPredictionStats(stats);
    }

    setSubmitting(false);
  }

  if (!matchId) {
    return (
      <div className="screen">
        <header className="screen-header">
          <h1>Détail du match</h1>
        </header>
        <div className="screen-content">
          <div className="card">
            <p>Identifiant de match manquant.</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Détail du match</h1>
        <p>Match ID: {matchId}</p>
      </header>
      <div className="screen-content">
        <div className="card">
          {loading && <p>Chargement du match...</p>}
          {error && <p style={{ color: '#ff6b6b' }}>{error}</p>}
          {match && !loading && (
            <>
              <h2>
                {match.homeTeamName} vs {match.awayTeamName}
              </h2>
              <p style={{ opacity: 0.8, fontSize: '0.9rem' }}>{match.competition}</p>
              <p style={{ marginTop: '0.5rem' }}>
                Début:{' '}
                {match.startTime.toLocaleString([], {
                  hour: '2-digit',
                  minute: '2-digit',
                  day: '2-digit',
                  month: '2-digit'
                })}
              </p>
              <p>
                Statut:{' '}
                <strong>
                  {match.status === 'scheduled'
                    ? 'Programmé'
                    : match.status === 'live'
                    ? 'En direct'
                    : match.status === 'finished'
                    ? 'Terminé'
                    : 'Reporté'}
                </strong>
              </p>
              <p>
                Score: {match.homeScore} - {match.awayScore}{' '}
                {match.status === 'live' && typeof match.minute === 'number'
                  ? `(${match.minute}')`
                  : null}
              </p>
            </>
          )}
        </div>

        <div className="card">
          <h2>Pronostic</h2>
          {userPrediction && (
            <p style={{ marginBottom: '0.75rem', fontSize: '0.9rem' }}>
              Votre pronostic actuel:{' '}
              <strong>
                {userPrediction.prediction === 'team_a'
                  ? match?.homeTeamName
                  : userPrediction.prediction === 'team_b'
                  ? match?.awayTeamName
                  : 'Match nul'}
              </strong>
            </p>
          )}

          <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '0.75rem' }}>
            <button
              type="button"
              disabled={!canPredict}
              onClick={() => setSelectedPrediction('team_a')}
              className="tile"
              style={
                selectedPrediction === 'team_a'
                  ? { borderColor: '#19db8a', boxShadow: '0 0 0 1px #19db8a' }
                  : undefined
              }
            >
              {match?.homeTeamName ?? 'Équipe A'}
            </button>
            <button
              type="button"
              disabled={!canPredict}
              onClick={() => setSelectedPrediction('draw')}
              className="tile"
              style={
                selectedPrediction === 'draw'
                  ? { borderColor: '#19db8a', boxShadow: '0 0 0 1px #19db8a' }
                  : undefined
              }
            >
              Nul
            </button>
            <button
              type="button"
              disabled={!canPredict}
              onClick={() => setSelectedPrediction('team_b')}
              className="tile"
              style={
                selectedPrediction === 'team_b'
                  ? { borderColor: '#19db8a', boxShadow: '0 0 0 1px #19db8a' }
                  : undefined
              }
            >
              {match?.awayTeamName ?? 'Équipe B'}
            </button>
          </div>

          {!canPredict && (
            <p style={{ fontSize: '0.85rem', opacity: 0.8 }}>
              Les pronostics ne sont plus disponibles pour ce match (ou vous avez déjà pronostiqué).
            </p>
          )}

          <button
            type="button"
            onClick={() => void handleSubmit()}
            disabled={!canPredict || !selectedPrediction || submitting}
            className="icon-button"
          >
            {submitting ? 'Envoi...' : 'Valider mon pronostic'}
          </button>

          {successMessage && (
            <p style={{ marginTop: '0.5rem', color: '#19db8a', fontSize: '0.85rem' }}>
              {successMessage}
            </p>
          )}
          {error && (
            <p style={{ marginTop: '0.5rem', color: '#ff6b6b', fontSize: '0.85rem' }}>{error}</p>
          )}
        </div>

        {predictionStats && (
          <div className="card">
            <h2>Répartition des pronostics</h2>
            <p style={{ fontSize: '0.9rem' }}>
              Total: {predictionStats.totalPredictions} pronostics
            </p>
            <ul style={{ listStyle: 'none', padding: 0, marginTop: '0.5rem' }}>
              <li>
                {match?.homeTeamName ?? 'Équipe A'}:{' '}
                <strong>{predictionStats.teamACount}</strong>
              </li>
              <li>
                Nul: <strong>{predictionStats.drawCount}</strong>
              </li>
              <li>
                {match?.awayTeamName ?? 'Équipe B'}:{' '}
                <strong>{predictionStats.teamBCount}</strong>
              </li>
            </ul>
          </div>
        )}
      </div>
    </div>
  );
};


