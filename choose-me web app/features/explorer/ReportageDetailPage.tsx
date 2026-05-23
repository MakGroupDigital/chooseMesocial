import React, { useEffect, useState } from 'react';
import { useLocation, useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Check, FileText, Heart, Share2, UserPlus } from 'lucide-react';
import { fetchReportages, incrementReportageShare, toggleReportageLike, type ReportageItem } from '../../services/reportageService';
import { getFirebaseAuth } from '../../services/firebase';
import { followAthlete, isFollowing, unfollowAthlete } from '../../services/followService';

type LocationState = {
  reportage?: ReportageItem;
};

const ReportageDetailPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const location = useLocation();
  const navigate = useNavigate();
  const state = location.state as LocationState | null;

  const [item, setItem] = useState<ReportageItem | null>(state?.reportage ?? null);
  const [loading, setLoading] = useState(!state?.reportage);
  const [currentUserId, setCurrentUserId] = useState('');
  const [isLiked, setIsLiked] = useState(false);
  const [isFollowingMedia, setIsFollowingMedia] = useState(false);
  const [actionLoading, setActionLoading] = useState(false);

  useEffect(() => {
    setCurrentUserId(getFirebaseAuth().currentUser?.uid || '');
  }, []);

  useEffect(() => {
    if (!item && id) {
      const load = async () => {
        setLoading(true);
        const all = await fetchReportages();
        const found = all.find((r) => r.id === id) ?? null;
        setItem(found);
        setLoading(false);
      };
      void load();
    }
  }, [id, item]);

  useEffect(() => {
    if (!item || !currentUserId) return;

    setIsLiked(item.likedBy.includes(currentUserId));
    if (item.reporterId && item.reporterId !== currentUserId) {
      isFollowing(currentUserId, item.reporterId)
        .then(setIsFollowingMedia)
        .catch(() => {});
    }
  }, [currentUserId, item]);

  const handleShare = async () => {
    if (!item) return;
    const url = `${window.location.origin}/#/explorer/reportage/${item.id}`;
    const text = `${item.title} - ${item.reporter}`;

    try {
      if (navigator.share) {
        await navigator.share({
          title: item.title,
          text,
          url
        });
      } else if (navigator.clipboard) {
        await navigator.clipboard.writeText(url);
        alert('Lien du reportage copié dans le presse-papiers.');
      } else {
        alert(url);
      }

      setItem((prev) => prev ? { ...prev, shares: prev.shares + 1 } : prev);
      await incrementReportageShare(item);
    } catch {
      // Partage annulé ou compteur indisponible.
    }
  };

  const handleLike = async () => {
    if (!item) return;
    if (!currentUserId) {
      navigate('/login');
      return;
    }
    if (actionLoading) return;

    const previousLiked = isLiked;
    setActionLoading(true);
    setIsLiked(!previousLiked);
    setItem((prev) => prev ? {
      ...prev,
      likes: previousLiked ? Math.max(0, prev.likes - 1) : prev.likes + 1,
      likedBy: previousLiked
        ? prev.likedBy.filter((id) => id !== currentUserId)
        : [...new Set([...prev.likedBy, currentUserId])]
    } : prev);

    try {
      await toggleReportageLike(item, currentUserId, previousLiked);
    } catch (error) {
      console.error('Like reportage impossible:', error);
      setIsLiked(previousLiked);
      setItem((prev) => prev ? {
        ...prev,
        likes: previousLiked ? prev.likes + 1 : Math.max(0, prev.likes - 1),
        likedBy: previousLiked
          ? [...new Set([...prev.likedBy, currentUserId])]
          : prev.likedBy.filter((id) => id !== currentUserId)
      } : prev);
    } finally {
      setActionLoading(false);
    }
  };

  const handleFollow = async () => {
    if (!item?.reporterId) return;
    if (!currentUserId) {
      navigate('/login');
      return;
    }
    if (item.reporterId === currentUserId || actionLoading) return;

    const previous = isFollowingMedia;
    setActionLoading(true);
    setIsFollowingMedia(!previous);
    try {
      if (previous) {
        await unfollowAthlete(currentUserId, item.reporterId);
      } else {
        await followAthlete(currentUserId, item.reporterId);
      }
    } catch (error) {
      console.error('Abonnement média impossible:', error);
      setIsFollowingMedia(previous);
    } finally {
      setActionLoading(false);
    }
  };

  if (!id) {
    navigate('/explorer', { replace: true });
    return null;
  }

  if (loading || !item) {
    return (
      <div className="h-full flex flex-col bg-[#050505]">
        <header className="px-4 pt-10 pb-4 flex items-center gap-3">
          <button
            onClick={() => navigate(-1)}
            className="p-2 rounded-full bg-black/40 border border-white/10 text-white"
          >
            <ArrowLeft size={18} />
          </button>
          <h1 className="text-white font-semibold text-sm">Reportage</h1>
        </header>
        <div className="flex-1 flex items-center justify-center">
          <p className="text-white/50 text-sm">Chargement du reportage...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="h-full flex flex-col bg-[#050505]">
      {/* Header */}
      <header className="px-4 pt-10 pb-3 flex items-center justify-between gap-3">
        <div className="flex items-center gap-3">
          <button
            onClick={() => navigate(-1)}
            className="p-2 rounded-full bg-black/40 border border-white/10 text-white"
          >
            <ArrowLeft size={18} />
          </button>
          <div className="flex flex-col">
            <span className="text-[11px] uppercase tracking-[0.2em] text-[#19DB8A] font-semibold">
              {item.kind === 'article' ? 'Article' : 'Reportage'}
            </span>
            <h1 className="text-white font-semibold text-sm line-clamp-1">
              {item.title}
            </h1>
          </div>
        </div>
        <button
          onClick={handleShare}
          className="p-2 rounded-full bg-black/40 border border-white/10 text-white"
        >
          <Share2 size={16} />
        </button>
      </header>

      {/* Media */}
      <div className="px-4">
        <div className="relative rounded-3xl overflow-hidden border border-white/10 bg-black shadow-xl">
          {item.mediaType === 'video' && item.videoUrl ? (
            <video
              src={item.videoUrl}
              className="w-full h-56 object-cover"
              controls
              playsInline
              preload="metadata"
            />
          ) : item.imageUrl ? (
            <img src={item.imageUrl} className="h-56 w-full object-cover" />
          ) : (
            <div className="flex h-44 items-center justify-center bg-[#0A0A0A] text-[#19DB8A]">
              <FileText size={34} />
            </div>
          )}
        </div>
      </div>

      {/* Infos */}
      <div className="flex-1 px-4 pt-4 pb-24 overflow-y-auto custom-scrollbar space-y-4">
        <div>
          <h2 className="text-white text-lg font-bold leading-snug">
            {item.title}
          </h2>
          <p className="text-white/50 text-xs mt-1">
            Par {item.reporter} • {item.date}
          </p>
        </div>

        <div className="flex flex-wrap items-center gap-2">
          <button
            onClick={handleLike}
            disabled={actionLoading}
            className={`flex items-center gap-2 rounded-full px-4 py-2 text-xs font-bold ${
              isLiked ? 'bg-[#19DB8A]/18 text-[#19DB8A]' : 'bg-white/[0.08] text-white/65'
            }`}
          >
            <Heart size={16} className={isLiked ? 'fill-current' : ''} />
            {item.likes}
          </button>
          <button
            onClick={handleShare}
            className="flex items-center gap-2 rounded-full bg-white/[0.08] px-4 py-2 text-xs font-bold text-white/65"
          >
            <Share2 size={16} />
            {item.shares}
          </button>
          {item.reporterId && item.reporterId !== currentUserId && (
            <button
              onClick={handleFollow}
              disabled={actionLoading}
              className={`flex items-center gap-2 rounded-full px-4 py-2 text-xs font-black uppercase ${
                isFollowingMedia ? 'bg-[#19DB8A] text-black' : 'bg-white/10 text-white'
              }`}
            >
              {isFollowingMedia ? <Check size={15} /> : <UserPlus size={15} />}
              {isFollowingMedia ? 'Suivi' : 'Suivre le média'}
            </button>
          )}
        </div>

        {item.detail && (
          <div className="bg-[#0A0A0A] border border-white/10 rounded-2xl p-4">
            <h3 className="text-white text-xs font-semibold mb-2 uppercase tracking-[0.18em]">
              Description
            </h3>
            <p className="text-white/80 text-sm whitespace-pre-wrap leading-relaxed">
              {item.detail}
            </p>
          </div>
        )}
      </div>
    </div>
  );
};

export default ReportageDetailPage;
