
import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Edit2, MapPin, Share2, Award, Activity, BrainCircuit, Trophy, MessageSquare, UserPlus, Check, AlertCircle } from 'lucide-react';
import { UserProfile, UserType } from '../../types';
import Button from '../../components/Button';
import { getTalentInsight } from '../../services/geminiService';

const ProfileViewPage: React.FC<{ user: UserProfile }> = ({ user }) => {
  const navigate = useNavigate();
  const [insight, setInsight] = useState<string | null>(null);
  const [loadingInsight, setLoadingInsight] = useState(false);
  const [isFollowing, setIsFollowing] = useState(false);

  // Pour l'instant, on considère que la page affiche toujours le profil connecté
  const viewerType = user.type;
  const isOwnProfile = true;
  const isRecruiterView = viewerType === UserType.RECRUITER || viewerType === UserType.CLUB;

  // Check for missing fields
  const missingFields = [];
  if (!user.country) missingFields.push('Pays');
  if (!user.sport && user.type === UserType.ATHLETE) missingFields.push('Sport');
  if (!user.position && user.type === UserType.ATHLETE) missingFields.push('Poste');
  if (!user.avatarUrl) missingFields.push('Photo de profil');

  useEffect(() => {
    const loadInsight = async () => {
      setLoadingInsight(true);
      const res = await getTalentInsight(user.displayName, user.stats);
      setInsight(res || null);
      setLoadingInsight(false);
    };
    if (user.type === UserType.ATHLETE) loadInsight();
  }, [user]);

  return (
    <div className="min-h-screen bg-[#050505]">
      {/* Header Overlay */}
      <div className="h-56 bg-gradient-to-br from-[#208050] to-[#0A0A0A] relative overflow-hidden">
        {/* Decor */}
        <div className="absolute top-[-10%] right-[-10%] w-64 h-64 bg-white/5 blur-[100px] rounded-full" />
        
        <div className="absolute top-12 left-6 right-6 flex justify-between z-10">
          <button onClick={() => navigate(-1)} className="p-2 bg-black/20 rounded-full text-white backdrop-blur-md">
             <ChevronLeft size={24} />
          </button>
          <div className="flex gap-3">
             <button className="p-2 bg-black/20 rounded-full text-white backdrop-blur-md">
                <Share2 size={20} />
             </button>
             {isOwnProfile && (
               <button onClick={() => navigate('/profile/edit')} className="p-2 bg-[#19DB8A] rounded-full text-white shadow-lg shadow-green-900/40">
                  <Edit2 size={20} />
               </button>
             )}
          </div>
        </div>
      </div>

      {/* Profile Content */}
      <div className="px-6 -mt-16 pb-32 relative z-20">
        {/* Missing Fields Alert */}
        {missingFields.length > 0 && isOwnProfile && (
          <div className="bg-[#FF8A3C]/10 border border-[#FF8A3C]/30 rounded-2xl p-4 mb-6 flex items-start gap-3">
            <AlertCircle size={20} className="text-[#FF8A3C] flex-shrink-0 mt-0.5" />
            <div className="flex-1">
              <p className="text-[#FF8A3C] text-sm font-semibold mb-1">Complétez votre profil</p>
              <p className="text-white/60 text-xs">Informations manquantes: {missingFields.join(', ')}</p>
              <button 
                onClick={() => navigate('/profile/edit')}
                className="text-[#FF8A3C] text-xs font-bold mt-2 hover:underline"
              >
                Compléter maintenant →
              </button>
            </div>
          </div>
        )}

        {/* Avatar & Basic Info */}
        <div className="flex flex-col items-center mb-8">
          <div className="relative">
            <img 
              src={user.avatarUrl || 'https://via.placeholder.com/144?text=No+Photo'} 
              className="w-36 h-36 rounded-[2.8rem] border-8 border-[#050505] shadow-2xl object-cover" 
              alt={user.displayName}
            />
            <div className="absolute -bottom-1 -right-1 bg-[#19DB8A] p-2.5 rounded-2xl border-4 border-[#050505] shadow-lg">
               <Award size={20} className="text-white" />
            </div>
          </div>
          
          <h1 className="mt-4 text-3xl font-readex font-bold text-white text-center flex items-center gap-2">
            {user.displayName || 'Utilisateur'}
            <div className="w-5 h-5 bg-[#19DB8A] rounded-full flex items-center justify-center p-1">
               <Check size={12} strokeWidth={4} className="text-black" />
            </div>
          </h1>
          <div className="flex items-center gap-1 text-white/40 text-sm mt-1">
            <MapPin size={14} />
            <span>{user.country || 'Pays non défini'}</span>
            <span className="mx-2">•</span>
            <span className="bg-white/5 px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider text-[#19DB8A]">
              {user.type}
            </span>
          </div>
        </div>

        {/* Dynamic Action Buttons based on Role */}
        {!isOwnProfile && (
          <div className="grid grid-cols-2 gap-4 mb-8">
            <Button 
              onClick={() => setIsFollowing(!isFollowing)}
              variant={isFollowing ? 'secondary' : 'primary'}
              className="py-4"
            >
              {isFollowing ? 'Suivi' : <><UserPlus size={18} /> Suivre</>}
            </Button>
            
            {isRecruiterView ? (
              <Button className="py-4 bg-[#FF8A3C] border-[#FF8A3C] hover:bg-[#FF8A3C]/80">
                <MessageSquare size={18} /> Contacter
              </Button>
            ) : (
              <Button variant="secondary" className="py-4">Message</Button>
            )}
          </div>
        )}

        {/* AI Scouting Report (Only for Athletes) */}
        {user.type === UserType.ATHLETE && (
           <div className="bg-[#0A0A0A] border border-[#19DB8A]/20 rounded-[2rem] p-6 mb-8 relative overflow-hidden group shadow-2xl">
              <div className="absolute top-0 right-0 p-4 opacity-5 group-hover:opacity-10 transition-opacity">
                <BrainCircuit size={100} className="text-[#19DB8A]" />
              </div>
              <div className="flex items-center gap-2 mb-4">
                <BrainCircuit className="text-[#19DB8A]" size={20} />
                <h3 className="font-bold text-[#19DB8A] uppercase tracking-wider text-[10px]">Rapport de Scoutisme Choose-Me</h3>
              </div>
              <p className="text-white/80 text-sm leading-relaxed italic relative z-10">
                {loadingInsight ? (
                  <span className="flex items-center gap-2">
                    <span className="w-2 h-2 bg-[#19DB8A] rounded-full animate-pulse" />
                    Génération de l'analyse par IA...
                  </span>
                ) : insight || 'Complétez votre profil pour générer une analyse personnalisée.'}
              </p>
           </div>
        )}

        {/* Stats Grid */}
        <div className="grid grid-cols-3 gap-3 mb-10">
          <StatCard 
            icon={<Activity size={18} />} 
            label="Matchs" 
            value={user.stats?.matchesPlayed || '-'} 
            isEmpty={!user.stats?.matchesPlayed}
          />
          <StatCard 
            icon={<Trophy size={18} className="text-[#FF8A3C]" />} 
            label="Buts" 
            value={user.stats?.goals || '-'} 
            isEmpty={!user.stats?.goals}
          />
          <StatCard 
            icon={<Award size={18} className="text-[#19DB8A]" />} 
            label="Passes" 
            value={user.stats?.assists || '-'} 
            isEmpty={!user.stats?.assists}
          />
        </div>

        {/* Additional Info Section */}
        <div className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-6 mb-8">
          <h3 className="text-lg font-bold text-white mb-4">Informations</h3>
          <div className="space-y-4">
            <InfoRow 
              label="Sport" 
              value={user.sport || 'Non défini'} 
              isEmpty={!user.sport}
            />
            <InfoRow 
              label="Poste / Spécialité" 
              value={user.position || 'Non défini'} 
              isEmpty={!user.position}
            />
            <InfoRow 
              label="Email" 
              value={user.email || 'Non défini'} 
              isEmpty={!user.email}
            />
            <InfoRow 
              label="Pays" 
              value={user.country || 'Non défini'} 
              isEmpty={!user.country}
            />
          </div>
          {isOwnProfile && missingFields.length > 0 && (
            <button 
              onClick={() => navigate('/profile/edit')}
              className="w-full mt-6 py-3 bg-[#19DB8A] text-black font-bold rounded-2xl hover:bg-[#19DB8A]/90 transition-colors"
            >
              Compléter les informations
            </button>
          )}
        </div>

        {/* Media Feed */}
        <div className="space-y-6">
          <div className="flex items-center justify-between">
            <h3 className="text-xl font-bold font-readex">Performances</h3>
            <button className="text-[#19DB8A] text-xs font-bold uppercase tracking-widest">Voir Tout</button>
          </div>
          <div className="grid grid-cols-2 gap-4">
            {[1, 2, 3, 4].map(i => (
              <div key={i} className="aspect-[4/5] bg-[#0A0A0A] rounded-3xl border border-white/5 overflow-hidden relative shadow-lg group">
                <img src={`https://picsum.photos/seed/${i + 20}/300/400`} className="w-full h-full object-cover opacity-60 group-hover:scale-110 transition-transform duration-700" />
                <div className="absolute inset-0 flex items-center justify-center">
                   <div className="w-12 h-12 bg-white/10 backdrop-blur-md rounded-full flex items-center justify-center border border-white/20">
                      <Activity size={24} className="text-white" />
                   </div>
                </div>
                <div className="absolute bottom-4 left-4 right-4">
                   <div className="h-1 w-full bg-white/20 rounded-full overflow-hidden">
                      <div className="h-full bg-[#19DB8A] w-[60%]" />
                   </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

// Internal Helper Icons
const ChevronLeft = ({ size, className }: any) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <path d="m15 18-6-6 6-6"/>
  </svg>
);

const StatCard: React.FC<{ icon: React.ReactNode; label: string; value: number | string; isEmpty?: boolean }> = ({ icon, label, value, isEmpty }) => (
  <div className={`bg-[#0A0A0A] border rounded-3xl p-5 flex flex-col items-center shadow-xl ${isEmpty ? 'border-white/5 opacity-60' : 'border-white/5'}`}>
    <div className={isEmpty ? 'text-white/20' : 'text-white/30'}>{icon}</div>
    <span className={`text-2xl font-readex font-bold mt-2 ${isEmpty ? 'text-white/40' : 'text-white'}`}>{value}</span>
    <span className="text-[9px] text-white/30 uppercase font-bold tracking-widest mt-1">{label}</span>
  </div>
);

const InfoRow: React.FC<{ label: string; value: string; isEmpty?: boolean }> = ({ label, value, isEmpty }) => (
  <div className="flex items-center justify-between py-3 border-b border-white/5 last:border-b-0">
    <span className="text-white/60 text-sm">{label}</span>
    <span className={`font-semibold ${isEmpty ? 'text-white/30 italic' : 'text-white'}`}>
      {isEmpty ? 'À compléter' : value}
    </span>
  </div>
);

export default ProfileViewPage;
