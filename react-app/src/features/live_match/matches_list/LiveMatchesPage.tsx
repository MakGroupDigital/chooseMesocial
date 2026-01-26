import React, { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  FootballApiService,
  MatchData,
  ApiResult
} from '../services/footballApiService';

// Correspond à `MatchesListWidget` côté Flutter, avec logique métier réelle.

type SectionedMatches = {
  upcoming: MatchData[];
  live: MatchData[];
  finished: MatchData[];
};

export const LiveMatchesPage: React.FC = () => {
  const [matches, setMatches] = useState<MatchData[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isFromCache, setIsFromCache] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const navigate = useNavigate();

  useEffect(() => {
    void loadMatches();
  }, []);

  async function loadMatches() {
    setIsLoading(true);
    setError(null);
    const result: ApiResult<MatchData[]> =
      await FootballApiService.instance.getTodayMatches();

    if (result.kind === 'error') {
      setError(result.error);
      setMatches([]);
      setIsFromCache(false);
    } else {
      setMatches(result.data);
      setIsFromCache(result.kind === 'cached' || result.isFromCache === true);
    }
    setIsLoading(false);
  }

  const sections = useMemo<SectionedMatches>(() => {
    const upcoming: MatchData[] = [];
    const live: MatchData[] = [];
    const finished: MatchData[] = [];

    matches.forEach((m) => {
      if (m.status === 'live') live.push(m);
      else if (m.status === 'finished') finished.push(m);
      else upcoming.push(m);
    });

    return { upcoming, live, finished };
  }, [matches]);

  const hasAnyMatch =
    sections.upcoming.length + sections.live.length + sections.finished.length > 0;

  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Matchs en direct</h1>
        <p>Faites vos pronostics et gagnez des récompenses</p>
      </header>

      <div className="screen-content">
        <div className="card" style={{ marginBottom: '1rem' }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div>
              <strong>Statut des données</strong>
              <p style={{ margin: '0.25rem 0 0', fontSize: '0.85rem', opacity: 0.8 }}>
                {isLoading
                  ? 'Chargement des matchs...'
                  : isFromCache
                  ? 'Données en cache / mode test (API ou Firestore indisponible)'
                  : 'Données à jour depuis Firestore'}
              </p>
            </div>
            <button className="icon-button" type="button" onClick={() => void loadMatches()}>
              ⟳
            </button>
          </div>
          {error && (
            <p style={{ marginTop: '0.5rem', color: '#ff6b6b', fontSize: '0.85rem' }}>
              {error}
            </p>
          )}
        </div>

        {isLoading && (
          <div className="card">
            <p>Chargement des matchs...</p>
          </div>
        )}

        {!isLoading && !hasAnyMatch && (
          <div className="card">
            <h2>Aucun match aujourd&apos;hui</h2>
            <p>Revenez plus tard pour voir les prochains matchs.</p>
            <button
              className="icon-button"
              type="button"
              onClick={() => void loadMatches()}
              style={{ marginTop: '0.75rem' }}
            >
              Actualiser
            </button>
          </div>
        )}

        {!isLoading && hasAnyMatch && (
          <>
            {sections.live.length > 0 && (
              <MatchesSection
                title="En cours"
                subtitle="Matches en direct avec mise à jour en temps réel"
                matches={sections.live}
                onOpenMatch={(id) => navigate(`/live-match/${id}`)}
              />
            )}

            {sections.upcoming.length > 0 && (
              <MatchesSection
                title="À venir"
                subtitle="Matchs programmés pour aujourd'hui"
                matches={sections.upcoming}
                onOpenMatch={(id) => navigate(`/live-match/${id}`)}
              />
            )}

            {sections.finished.length > 0 && (
              <MatchesSection
                title="Résultats récents"
                subtitle="Matches terminés récemment"
                matches={sections.finished}
                onOpenMatch={(id) => navigate(`/live-match/${id}`)}
              />
            )}
          </>
        )}
      </div>
    </div>
  );
};

interface MatchesSectionProps {
  title: string;
  subtitle: string;
  matches: MatchData[];
  onOpenMatch: (id: string) => void;
}

const MatchesSection: React.FC<MatchesSectionProps> = ({
  title,
  subtitle,
  matches,
  onOpenMatch
}) => {
  return (
    <section className="card">
      <h2>{title}</h2>
      <p>{subtitle}</p>
      <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
        {matches.map((m) => (
          <button
            key={m.id}
            type="button"
            onClick={() => onOpenMatch(m.id)}
            style={{
              textAlign: 'left',
              width: '100%',
              borderRadius: 12,
              border: '1px solid rgba(255,255,255,0.08)',
              background: 'rgba(0,0,0,0.3)',
              padding: '0.75rem 0.9rem',
              cursor: 'pointer'
            }}
          >
            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                alignItems: 'center',
                gap: '0.75rem'
              }}
            >
              <div style={{ flex: 1 }}>
                <div
                  style={{
                    fontSize: '0.8rem',
                    opacity: 0.8,
                    marginBottom: '0.2rem'
                  }}
                >
                  {m.competition}
                </div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                  <span>{m.homeTeamName}</span>
                  <span style={{ opacity: 0.7 }}>vs</span>
                  <span>{m.awayTeamName}</span>
                </div>
              </div>
              <div style={{ textAlign: 'right', fontSize: '0.85rem' }}>
                {m.status === 'scheduled' && (
                  <span style={{ color: '#19db8a' }}>
                    {m.startTime.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                  </span>
                )}
                {m.status === 'live' && (
                  <span style={{ color: '#ff6b6b', fontWeight: 600 }}>
                    {m.homeScore} - {m.awayScore}{' '}
                    {typeof m.minute === 'number' ? `(${m.minute}')` : null}
                  </span>
                )}
                {m.status === 'finished' && (
                  <span>
                    {m.homeScore} - {m.awayScore}
                  </span>
                )}
              </div>
            </div>
          </button>
        ))}
      </div>
    </section>
  );
};


