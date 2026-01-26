
import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ChevronLeft, BrainCircuit, Users, TrendingUp } from 'lucide-react';
import Button from '../../components/Button';
import { getMatchPredictionInsight } from '../../services/geminiService';

const MatchDetailPage: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();
  const [selectedBet, setSelectedBet] = useState<string | null>(null);
  const [aiInsight, setAiInsight] = useState<string | null>(null);
  const [loadingAi, setLoadingAi] = useState(false);

  // Mock data for the specific match
  const match = { 
    id, 
    teamA: 'Sénégal', 
    teamB: 'Côte d\'Ivoire', 
    logoA: 'https://flagsapi.com/SN/flat/128.png', 
    logoB: 'https://flagsapi.com/CI/flat/128.png', 
    scoreA: 1, 
    scoreB: 1, 
    status: 'live', 
    minute: 74,
    stats: {
      possessionA: 55,
      possessionB: 45,
      shotsA: 12,
      shotsB: 8
    }
  };

  useEffect(() => {
    const loadAi = async () => {
      setLoadingAi(true);
      const insight = await getMatchPredictionInsight(match);
      setAiInsight(insight);
      setLoadingAi(false);
    };
    loadAi();
  }, [id]);

  return (
    <div className="min-h-screen bg-[#050505]">
      {/* Header */}
      <div className="relative h-64 bg-gradient-to-b from-[#208050]/30 to-[#050505] p-6">
        <button onClick={() => navigate(-1)} className="text-white/60 hover:text-white mb-8">
          <ChevronLeft size={32} />
        </button>

        <div className="flex items-center justify-between">
          <div className="flex flex-col items-center flex-1">
            <img src={match.logoA} alt={match.teamA} className="w-20 h-20 object-contain drop-shadow-2xl" />
            <h2 className="mt-3 font-readex font-bold text-lg">{match.teamA}</h2>
          </div>

          <div className="flex flex-col items-center px-4">
            <span className="text-red-500 text-xs font-bold animate-pulse mb-2">LIVE {match.minute}'</span>
            <div className="text-5xl font-readex font-bold flex gap-4">
              <span>{match.scoreA}</span>
              <span className="text-white/20">-</span>
              <span>{match.scoreB}</span>
            </div>
          </div>

          <div className="flex flex-col items-center flex-1">
            <img src={match.logoB} alt={match.teamB} className="w-20 h-20 object-contain drop-shadow-2xl" />
            <h2 className="mt-3 font-readex font-bold text-lg">{match.teamB}</h2>
          </div>
        </div>
      </div>

      <div className="p-6 -mt-8 space-y-6">
        {/* AI Insight Card */}
        <div className="bg-[#0A0A0A] border border-[#19DB8A]/20 rounded-3xl p-5 shadow-lg relative overflow-hidden">
          <div className="absolute top-0 right-0 p-4 opacity-10">
            <BrainCircuit size={48} className="text-[#19DB8A]" />
          </div>
          <div className="flex items-center gap-2 mb-3">
            <BrainCircuit className="text-[#19DB8A]" size={20} />
            <h3 className="font-bold text-[#19DB8A] uppercase tracking-wider text-xs">Intelligence Choose-Me</h3>
          </div>
          <p className="text-white/80 text-sm leading-relaxed italic">
            {loadingAi ? 'Génération de l\'analyse...' : aiInsight || "Le Sénégal domine la possession mais la Côte d'Ivoire est dangereuse en contre-attaque. Probabilité de nul élevée (40%)."}
          </p>
        </div>

        {/* Prediction UI */}
        <div className="space-y-4">
          <h3 className="text-xl font-bold flex items-center gap-2">
            <TrendingUp className="text-[#FF8A3C]" />
            Votre Pronostic
          </h3>
          <div className="grid grid-cols-3 gap-3">
            {[
              { id: 'team_a', label: '1', name: match.teamA },
              { id: 'draw', label: 'X', name: 'Nul' },
              { id: 'team_b', label: '2', name: match.teamB }
            ].map((option) => (
              <button
                key={option.id}
                onClick={() => setSelectedBet(option.id)}
                className={`p-4 rounded-2xl flex flex-col items-center justify-center gap-1 border-2 transition-all ${
                  selectedBet === option.id 
                    ? 'bg-[#208050] border-[#19DB8A] shadow-lg shadow-green-900/30' 
                    : 'bg-[#0A0A0A] border-white/5 text-white/40'
                }`}
              >
                <span className="text-2xl font-black">{option.label}</span>
                <span className="text-[10px] uppercase font-bold text-center line-clamp-1">{option.name}</span>
              </button>
            ))}
          </div>
          <Button disabled={!selectedBet} className="w-full py-4 text-lg">Valider mon prono</Button>
        </div>

        {/* Live Stats */}
        <div className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-6 space-y-6">
          <h3 className="font-bold flex items-center gap-2 text-white/60">
            <Users size={18} /> Statistiques Match
          </h3>
          
          <div className="space-y-4">
            <StatBar label="Possession" valA={match.stats.possessionA} valB={match.stats.possessionB} />
            <StatBar label="Tirs" valA={match.stats.shotsA} valB={match.stats.shotsB} isUnitless />
          </div>
        </div>
      </div>
    </div>
  );
};

const StatBar: React.FC<{ label: string; valA: number; valB: number; isUnitless?: boolean }> = ({ label, valA, valB, isUnitless }) => {
  const total = valA + valB;
  const percA = (valA / total) * 100;

  return (
    <div className="space-y-1.5">
      <div className="flex justify-between text-xs font-bold text-white/50 px-1 uppercase tracking-tighter">
        <span>{valA}{!isUnitless && '%'}</span>
        <span>{label}</span>
        <span>{valB}{!isUnitless && '%'}</span>
      </div>
      <div className="h-1.5 w-full bg-white/5 rounded-full flex overflow-hidden">
        <div className="bg-[#208050] h-full" style={{ width: `${percA}%` }} />
        <div className="bg-white/10 h-full flex-1" />
        <div className="bg-[#FF8A3C] h-full" style={{ width: `${100 - percA}%` }} />
      </div>
    </div>
  );
};

export default MatchDetailPage;
