
import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Trophy, Clock, PlayCircle } from 'lucide-react';
import { MatchData } from '../../types';

const MOCK_MATCHES: MatchData[] = [
  { id: '1', teamA: 'Sénégal', teamB: 'Côte d\'Ivoire', logoA: 'https://flagsapi.com/SN/flat/64.png', logoB: 'https://flagsapi.com/CI/flat/64.png', scoreA: 1, scoreB: 1, status: 'live', minute: 74, startTime: '2024-05-20T20:00:00Z' },
  { id: '2', teamA: 'Maroc', teamB: 'Égypte', logoA: 'https://flagsapi.com/MA/flat/64.png', logoB: 'https://flagsapi.com/EG/flat/64.png', scoreA: 0, scoreB: 0, status: 'scheduled', startTime: '2024-05-21T18:00:00Z' },
  { id: '3', teamA: 'Nigéria', teamB: 'Cameroun', logoA: 'https://flagsapi.com/NG/flat/64.png', logoB: 'https://flagsapi.com/CM/flat/64.png', scoreA: 2, scoreB: 0, status: 'finished', startTime: '2024-05-19T21:00:00Z' },
];

const LiveMatchesPage: React.FC = () => {
  const [filter, setFilter] = useState<'live' | 'scheduled' | 'finished'>('live');
  const navigate = useNavigate();

  const filteredMatches = MOCK_MATCHES.filter(m => m.status === filter);

  return (
    <div className="p-6">
      <header className="mb-8">
        <h1 className="text-3xl font-readex font-bold text-white flex items-center gap-3">
          <Trophy className="text-[#FF8A3C]" />
          Matchs en Live
        </h1>
        <p className="text-white/40 mt-1">Pronostiquez et gagnez des points</p>
      </header>

      {/* Filter Tabs */}
      <div className="flex bg-[#0A0A0A] p-1 rounded-2xl mb-8 border border-white/5">
        {(['live', 'scheduled', 'finished'] as const).map((tab) => (
          <button
            key={tab}
            onClick={() => setFilter(tab)}
            className={`flex-1 py-3 rounded-xl text-sm font-semibold capitalize transition-all ${
              filter === tab ? 'bg-[#208050] text-white shadow-lg' : 'text-white/40 hover:text-white'
            }`}
          >
            {tab === 'live' ? 'En Direct' : tab === 'scheduled' ? 'À Venir' : 'Terminés'}
          </button>
        ))}
      </div>

      {/* Match List */}
      <div className="space-y-4">
        {filteredMatches.length > 0 ? (
          filteredMatches.map((match) => (
            <div
              key={match.id}
              onClick={() => navigate(`/live-match/${match.id}`)}
              className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-5 hover:border-[#19DB8A]/30 transition-all active:scale-[0.98] cursor-pointer"
            >
              <div className="flex justify-between items-center mb-4">
                <span className={`text-[10px] font-bold px-2 py-1 rounded flex items-center gap-1 ${
                  match.status === 'live' ? 'bg-red-500/20 text-red-500' : 'bg-white/5 text-white/40'
                }`}>
                  {match.status === 'live' ? (
                    <>
                      <div className="w-1.5 h-1.5 bg-red-500 rounded-full animate-pulse" />
                      LIVE {match.minute}'
                    </>
                  ) : (
                    <>
                      <Clock size={12} />
                      {new Date(match.startTime).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                    </>
                  )}
                </span>
                <span className="text-white/30 text-xs">Africa Cup of Nations</span>
              </div>

              <div className="flex items-center justify-between">
                <div className="flex flex-col items-center flex-1">
                  <img src={match.logoA} alt={match.teamA} className="w-14 h-14 object-contain mb-2" />
                  <p className="font-bold text-sm text-center line-clamp-1">{match.teamA}</p>
                </div>

                <div className="flex flex-col items-center px-4">
                  <div className="text-3xl font-readex font-bold flex gap-3">
                    <span>{match.scoreA}</span>
                    <span className="text-white/20">-</span>
                    <span>{match.scoreB}</span>
                  </div>
                </div>

                <div className="flex flex-col items-center flex-1">
                  <img src={match.logoB} alt={match.teamB} className="w-14 h-14 object-contain mb-2" />
                  <p className="font-bold text-sm text-center line-clamp-1">{match.teamB}</p>
                </div>
              </div>
              
              <div className="mt-5 pt-4 border-t border-white/5 flex justify-center">
                <p className="text-[#19DB8A] text-xs font-semibold flex items-center gap-2">
                   <PlayCircle size={14} /> Pronostiquer maintenant
                </p>
              </div>
            </div>
          ))
        ) : (
          <div className="text-center py-20 bg-[#0A0A0A] rounded-3xl border border-dashed border-white/10">
            <p className="text-white/30">Aucun match disponible pour le moment</p>
          </div>
        )}
      </div>
    </div>
  );
};

export default LiveMatchesPage;
