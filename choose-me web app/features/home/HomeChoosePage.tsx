
import React, { useEffect, useState } from 'react';
import { Bell, Heart, UserPlus, UserCheck } from 'lucide-react';
import { UserType, FeedPost, PostComment } from '../../types';
import { MOCK_USER, COLORS } from '../../constants';
import { fetchVideoFeed } from '../../services/feedService';
import { fetchComments, addComment, likeComment } from '../../services/commentService';
import { followAthlete, unfollowAthlete, isFollowing } from '../../services/followService';
import { IconLike, IconComment, IconShare, IconVolume, IconVolumeMuted } from '../../components/Icons';

const MOCK_FEED: FeedPost[] = [
  {
    id: 'p1',
    userId: 'u2',
    userName: 'Sadio Mané Jr',
    userAvatar: 'https://picsum.photos/seed/sadio/100',
    type: 'video',
    url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    thumbnail: 'https://picsum.photos/seed/vid1/400/600',
    caption: 'Entraînement intense ce matin. On ne lâche rien ! 🇸🇳⚽️',
    likes: 1240,
    shares: 45,
    comments: 32,
    createdAt: '2h',
    hashtags: ['Football', 'TalentAfrique', 'Scouting']
  },
  {
    id: 'p2',
    userId: 'u3',
    userName: 'Moussa Ndiaye',
    userAvatar: 'https://picsum.photos/seed/moussa/100',
    type: 'video',
    url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
    thumbnail: 'https://picsum.photos/seed/vid2/400/600',
    caption: 'Petit geste technique du weekend. Le talent est là !',
    likes: 850,
    shares: 12,
    comments: 14,
    createdAt: '5h',
    hashtags: ['Basket', 'Highlight', 'AfroTalent']
  }
];

const HomeChoosePage: React.FC<{ userType: UserType }> = ({ userType }) => {
  const [likedPosts, setLikedPosts] = useState<Set<string>>(new Set());
  const [followingUsers, setFollowingUsers] = useState<Set<string>>(new Set());
  const [feed, setFeed] = useState<FeedPost[]>(MOCK_FEED);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [isMuted, setIsMuted] = useState(true);
  const [activeCommentsPost, setActiveCommentsPost] = useState<FeedPost | null>(null);
  const [comments, setComments] = useState<PostComment[]>([]);
  const [commentsLoading, setCommentsLoading] = useState(false);
  const [newComment, setNewComment] = useState('');
  const [likedComments, setLikedComments] = useState<Set<string>>(new Set());
  const [followingLoading, setFollowingLoading] = useState<Set<string>>(new Set());

  useEffect(() => {
    // Charge les vidéos en arrière-plan sans bloquer l'affichage
    const loadInBackground = async () => {
      try {
        const videos = await fetchVideoFeed();
        if (videos.length > 0) {
          setFeed(videos);
        }
        // Si aucune vidéo, on garde le MOCK_FEED
      } catch (e) {
        console.error('Erreur chargement vidéos:', e);
        // On garde le MOCK_FEED en cas d'erreur
      }
    };
    void loadInBackground();
  }, []);

  const toggleLike = (id: string) => {
    const newLiked = new Set(likedPosts);
    if (newLiked.has(id)) newLiked.delete(id);
    else newLiked.add(id);
    setLikedPosts(newLiked);
  };

  const toggleMute = () => {
    setIsMuted((prev) => !prev);
  };

  const handleFollowToggle = async (post: FeedPost) => {
    if (!MOCK_USER.uid) {
      alert('Veuillez vous connecter pour suivre des athlètes');
      return;
    }

    setFollowingLoading((prev) => new Set(prev).add(post.userId));

    try {
      const isCurrentlyFollowing = followingUsers.has(post.userId);

      if (isCurrentlyFollowing) {
        await unfollowAthlete(MOCK_USER.uid, post.userId);
        setFollowingUsers((prev) => {
          const newSet = new Set(prev);
          newSet.delete(post.userId);
          return newSet;
        });
      } else {
        await followAthlete(MOCK_USER.uid, post.userId);
        setFollowingUsers((prev) => new Set(prev).add(post.userId));
      }
    } catch (e) {
      console.error('Erreur lors du suivi:', e);
      alert('Erreur lors de la mise à jour du suivi');
    } finally {
      setFollowingLoading((prev) => {
        const newSet = new Set(prev);
        newSet.delete(post.userId);
        return newSet;
      });
    }
  };

  const openComments = async (post: FeedPost) => {
    setActiveCommentsPost(post);
    setComments([]);
    setCommentsLoading(true);
    try {
      if (!post.docPath) {
        setComments([]);
      } else {
        const list = await fetchComments(post.docPath);
        setComments(list);
      }
    } finally {
      setCommentsLoading(false);
    }
  };

  const closeComments = () => {
    setActiveCommentsPost(null);
    setComments([]);
  };

  const handleSendComment = async () => {
    if (!activeCommentsPost || !newComment.trim()) return;
    if (!activeCommentsPost.docPath) return;

    const optimistic: PostComment = {
      id: `local-${Date.now()}`,
      userId: MOCK_USER.uid || 'anonymous',
      userName: MOCK_USER.displayName || 'Utilisateur',
      userAvatar: MOCK_USER.avatarUrl,
      text: newComment.trim(),
      createdAt: new Date().toLocaleString(),
      likes: 0
    };

    setComments((prev) => [...prev, optimistic]);
    setNewComment('');

    try {
      await addComment({
        docPath: activeCommentsPost.docPath,
        userId: optimistic.userId,
        userName: optimistic.userName,
        userAvatar: optimistic.userAvatar,
        text: optimistic.text
      });

      // Met à jour le compteur localement pour le post actif
      setFeed((prev) =>
        prev.map((p) =>
          p.id === activeCommentsPost.id ? { ...p, comments: p.comments + 1 } : p
        )
      );
    } catch (e) {
      // Si l'envoi échoue, on retire le commentaire optimiste
      setComments((prev) => prev.filter((c) => c.id !== optimistic.id));
      alert("Impossible d'envoyer le commentaire pour le moment.");
    }
  };

  const handleLikeComment = async (comment: PostComment) => {
    if (!activeCommentsPost?.docPath) return;
    if (likedComments.has(comment.id)) return; // éviter plusieurs likes locaux sur le même commentaire

    setLikedComments((prev) => new Set(prev).add(comment.id));
    // Optimiste : +1 en local
    setComments((prev) =>
      prev.map((c) => (c.id === comment.id ? { ...c, likes: c.likes + 1 } : c))
    );

    try {
      await likeComment({ docPath: activeCommentsPost.docPath, commentId: comment.id });
    } catch {
      // rollback si erreur
      setLikedComments((prev) => {
        const copy = new Set(prev);
        copy.delete(comment.id);
        return copy;
      });
      setComments((prev) =>
        prev.map((c) => (c.id === comment.id ? { ...c, likes: Math.max(0, c.likes - 1) } : c))
      );
    }
  };

  return (
    <div className="h-full flex flex-col bg-[#050505]">
      {/* Dynamic Header */}
      <header className="fixed top-12 left-0 right-0 z-50 px-6 flex justify-between items-center pointer-events-none">
        <div className="flex gap-3 pointer-events-auto bg-black/40 rounded-full px-1 py-1 border border-white/10">
          <button className="text-sm font-readex font-semibold text-white tracking-tight px-3 py-1 rounded-full bg-[#208050]">
            Pour vous
          </button>
          <button className="text-sm font-readex font-semibold text-white/40 tracking-tight px-3 py-1 rounded-full">
            Abonnements
          </button>
        </div>
        <div className="flex gap-3 pointer-events-auto">
          <button className="p-2 bg-black/20 backdrop-blur-md rounded-full border border-white/10 text-white">
            <Bell size={20} />
          </button>
          <div className="w-10 h-10 rounded-full border-2 border-[#19DB8A] overflow-hidden">
            <img src={MOCK_USER.avatarUrl} alt="Me" className="w-full h-full object-cover" />
          </div>
        </div>
      </header>

      {/* Vertical Performance Feed */}
      <div className="flex-1 overflow-y-scroll snap-y snap-mandatory custom-scrollbar">
        {loading && (
          <div className="h-full flex items-center justify-center">
            <p className="text-white/60 text-sm">Chargement des vidéos...</p>
          </div>
        )}
        {!loading && error && (
          <div className="h-full flex items-center justify-center">
            <p className="text-red-400 text-sm">{error}</p>
          </div>
        )}
        {!loading && !error && feed.length === 0 && (
          <div className="h-full flex items-center justify-center">
            <p className="text-white/60 text-sm">Aucune vidéo disponible pour le moment.</p>
          </div>
        )}
        {!loading && !error && feed.map((post) => (
          <div key={post.id} className="relative h-full w-full snap-start overflow-hidden">
            {/* Vidéo HTML5 en plein écran - lecture automatique */}
            <video
              src={post.url}
              poster={post.thumbnail || '/assets/images/Untitled.gif'}
              className="w-full h-full object-cover"
              autoPlay
              muted={isMuted}
              loop
              playsInline
            />

            {/* Interactions Bar */}
            <div className="absolute right-4 bottom-28 flex flex-col gap-5 items-center">
              {/* Mute / Unmute audio */}
              <button
                onClick={toggleMute}
                className="flex flex-col items-center"
              >
                <div className="p-3 rounded-full bg-black/20 backdrop-blur-md text-white">
                  {isMuted ? <IconVolumeMuted size={20} /> : <IconVolume size={20} />}
                </div>
              </button>

              {/* Follow Button */}
              <button
                onClick={() => handleFollowToggle(post)}
                disabled={followingLoading.has(post.userId)}
                className="flex flex-col items-center group"
              >
                <div className={`p-3 rounded-full backdrop-blur-md transition-all ${
                  followingUsers.has(post.userId)
                    ? 'bg-[#19DB8A]/20 text-[#19DB8A]'
                    : 'bg-black/20 text-white'
                } ${followingLoading.has(post.userId) ? 'opacity-50' : ''}`}>
                  {followingUsers.has(post.userId) ? (
                    <UserCheck size={20} />
                  ) : (
                    <UserPlus size={20} />
                  )}
                </div>
              </button>

              <div className="flex flex-col items-center">
                <div className="w-12 h-12 rounded-full border-2 border-white overflow-hidden shadow-xl mb-1">
                  <img src={post.userAvatar} className="w-full h-full object-cover" />
                </div>
                <div className="bg-[#19DB8A] rounded-full p-1 -mt-3 relative z-10 border-2 border-black">
                  <PlusCircle size={10} className="text-white" />
                </div>
              </div>

              <button 
                onClick={() => toggleLike(post.id)}
                className="flex flex-col items-center group"
              >
                <div className={`p-3 rounded-full bg-black/20 backdrop-blur-md transition-all ${likedPosts.has(post.id) ? 'text-[#FF4B5C] scale-125' : 'text-white'}`}>
                  <IconLike size={24} />
                </div>
                <span className="text-white text-xs font-bold mt-1">{post.likes + (likedPosts.has(post.id) ? 1 : 0)}</span>
              </button>

              <button
                className="flex flex-col items-center"
                onClick={() => openComments(post)}
              >
                <div className="p-3 rounded-full bg-black/20 backdrop-blur-md text-white">
                  <IconComment size={24} />
                </div>
                <span className="text-white text-xs font-bold mt-1">{post.comments}</span>
              </button>

              <button className="flex flex-col items-center">
                <div className="p-3 rounded-full bg-black/20 backdrop-blur-md text-white">
                  <IconShare size={24} />
                </div>
                <span className="text-white text-xs font-bold mt-1">{post.shares}</span>
              </button>
            </div>

            {/* Post Info */}
            <div className="absolute left-6 right-24 bottom-24">
              <h3 className="text-white font-bold text-[15px] mb-1 flex items-center gap-2">
                @{post.userName}
                <span className="bg-[#208050] text-[9px] px-2 py-0.5 rounded-full uppercase tracking-widest">
                  Talent
                </span>
              </h3>
              <p className="text-white/85 text-[13px] leading-snug line-clamp-3">
                {post.caption}
              </p>
              {post.hashtags && post.hashtags.length > 0 && (
                <div className="mt-4 flex items-center gap-2">
                  <div className="flex gap-1 flex-wrap">
                    {post.hashtags.slice(0, 4).map((tag) => (
                      <span
                        key={tag}
                        className="text-[#19DB8A] text-xs font-medium"
                      >
                        #{tag.replace(/^#/, '')}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>
          </div>
        ))}
      </div>

      {/* Overlay commentaires */}
      {activeCommentsPost && (
        <div className="fixed inset-0 z-[80] bg-black/60 flex items-end justify-center">
          {/* On remonte nettement le panneau pour éviter toute superposition avec la bottom bar */}
          <div className="w-full max-w-md bg-[#050505] rounded-t-3xl p-4 border-t border-white/10 mb-20">
            <div className="flex items-center justify-between mb-3">
              <h4 className="text-white font-semibold text-sm">
                Commentaires sur la vidéo de @{activeCommentsPost.userName}
              </h4>
              <button
                onClick={closeComments}
                className="text-white/60 text-xs px-2 py-1 rounded-full border border-white/20"
              >
                Fermer
              </button>
            </div>
            {/* Liste des commentaires */}
            <div className="h-36 overflow-y-auto custom-scrollbar space-y-3 mb-4">
              {commentsLoading && (
                <p className="text-white/50 text-xs">Chargement des commentaires...</p>
              )}
              {!commentsLoading && comments.length === 0 && (
                <p className="text-white/40 text-xs">
                  Pas encore de commentaires. Soyez le premier à réagir !
                </p>
              )}
              {comments.map((c) => (
                <div key={c.id} className="flex items-start gap-2">
                  <div className="w-8 h-8 rounded-full overflow-hidden bg-white/10 flex-shrink-0">
                    {c.userAvatar ? (
                      <img src={c.userAvatar} className="w-full h-full object-cover" />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-xs text-white/70">
                        {c.userName.charAt(0).toUpperCase()}
                      </div>
                    )}
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center justify-between">
                      <div className="flex flex-col">
                        <span className="text-white text-xs font-semibold">@{c.userName}</span>
                        <span className="text-white/30 text-[10px]">{c.createdAt}</span>
                      </div>
                      <button
                        onClick={() => handleLikeComment(c)}
                        className={`flex items-center gap-1 px-2 py-0.5 rounded-full border ${
                          likedComments.has(c.id)
                            ? 'border-[#19DB8A] text-[#19DB8A]'
                            : 'border-white/20 text-white/60'
                        } text-[10px]`}
                      >
                        <Heart
                          size={12}
                          className={likedComments.has(c.id) ? 'fill-current' : ''}
                        />
                        <span>{c.likes}</span>
                      </button>
                    </div>
                    <p className="text-white/80 text-xs mt-0.5">{c.text}</p>
                  </div>
                </div>
              ))}
            </div>
            {/* Champ de saisie bien détaché de la barre de navigation */}
            <div className="flex items-center gap-2 pt-1">
              <input
                type="text"
                value={newComment}
                onChange={(e) => setNewComment(e.target.value)}
                placeholder="Écrire un commentaire..."
                className="flex-1 bg-black/40 border border-white/15 rounded-full px-3 py-1.5 text-xs text-white outline-none"
              />
              <button
                onClick={handleSendComment}
                disabled={!newComment.trim() || !activeCommentsPost?.docPath}
                className="px-3 py-1.5 bg-[#19DB8A] rounded-full text-xs font-semibold text-black disabled:opacity-40"
              >
                Envoyer
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

// Internal Helper
const PlusCircle = ({ size, className }: any) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <line x1="12" y1="5" x2="12" y2="19"></line>
    <line x1="5" y1="12" x2="19" y2="12"></line>
  </svg>
);

export default HomeChoosePage;
