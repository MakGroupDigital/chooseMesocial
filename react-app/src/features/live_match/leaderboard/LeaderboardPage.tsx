import React, { useEffect, useState } from 'react';
import { LeaderboardService, LeaderboardEntry } from '../services/leaderboardService';

// Correspond à `leaderboard_widget.dart` (classement des utilisateurs / pronostics)

export const LeaderboardPage: React.FC = () => {
  const [entries, setEntries] = useState<LeaderboardEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    void loadLeaderboard();
  }, []);

  async function loadLeaderboard() {
    try {
      setLoading(true);
      setError(null);
      const list = await LeaderboardService.instance.getGlobalLeaderboard({
        limit: 50,
        period: 'monthly'
      });
      setEntries(list);
    } catch (e: any) {
      setError(String(e));
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Classement</h1>
        <p>Voyez votre position dans le leaderboard.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <div
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              marginBottom: '0.5rem'
            }}
          >
            <div>
              <strong>Classement mensuel</strong>
              <p style={{ margin: 0, fontSize: '0.85rem', opacity: 0.8 }}>
                Basé sur les pronostics gagnants et le taux de réussite.
              </p>
            </div>
            <button className="icon-button" type="button" onClick={() => void loadLeaderboard()}>
              ⟳
            </button>
          </div>

          {loading && <p>Chargement du classement...</p>}
          {error && <p style={{ color: '#ff6b6b' }}>{error}</p>}

          {!loading && entries.length === 0 && (
            <p style={{ fontSize: '0.9rem' }}>Aucun pronostic gagnant pour l&apos;instant.</p>
          )}

          {!loading && entries.length > 0 && (
            <table
              style={{
                width: '100%',
                borderCollapse: 'collapse',
                marginTop: '0.5rem',
                fontSize: '0.9rem'
              }}
            >
              <thead>
                <tr>
                  <th style={{ textAlign: 'left' }}>#</th>
                  <th style={{ textAlign: 'left' }}>Utilisateur</th>
                  <th style={{ textAlign: 'right' }}>Pronostics</th>
                  <th style={{ textAlign: 'right' }}>Taux</th>
                  <th style={{ textAlign: 'right' }}>Gains (est.)</th>
                </tr>
              </thead>
              <tbody>
                {entries.map((e) => (
                  <tr key={e.userId}>
                    <td style={{ padding: '0.35rem 0' }}>{e.rank}</td>
                    <td>{e.userName}</td>
                    <td style={{ textAlign: 'right' }}>
                      {e.correctPredictions}/{e.totalPredictions}
                    </td>
                    <td style={{ textAlign: 'right' }}>{e.successRate.toFixed(1)}%</td>
                    <td style={{ textAlign: 'right' }}>{e.totalEarnings.toFixed(2)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
        </div>
      </div>
    </div>
  );
};

