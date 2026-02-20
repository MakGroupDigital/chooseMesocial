import React, { useEffect, useRef, useState } from 'react';
import { Bell, Heart, UserPlus, UserCheck } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import { UserType, FeedPost, PostComment } from '../../types';
import { fetchVideoFeed, getCachedVideoFeed } from '../../services/feedService';
import { fetchComments, addComment, likeComment } from '../../services/commentService';
import { followAthlete, unfollowAthlete, getFollowerCount, getFollowing } from '../../services/followService';
import { toggleLikePost, getUserLikedPosts } from '../../services/likeService';
import { shareVideoPost } from '../../services/shareService';
import { IconLike, IconComment, IconShare, IconVolume, IconVolumeMuted } from '../../components/Icons';
import { useAuth } from '../../services/firebase';
import { getFirestoreDb } from '../../services/firebase';
import { doc, getDoc } from 'firebase/firestore';
import { loadAppSettings, SETTINGS_EVENT } from '../../services/appSettingsService';
import type { PerformanceVideo } from '../../services/performanceService';

const HomeChoosePage: React.FC<{ userType: UserType }> = ({ userType: _userType }) => {
  const navigate = useNavigate();
  const { currentUser } = useAuth();

  const [likedPosts, setLikedPosts] = useState<Set<string>>(new Set());
  const [followingUsers, setFollowingUsers] = useState<Set<string>>(new Set());
  const [followerCounts, setFollowerCounts] = useState<Map<string, number>>(new Map());
  const [feed, setFeed] = useState<FeedPost[]>([]);
  const [allVideos, setAllVideos] = useState<FeedPost[]>([]);
  const [activeTab, setActiveTab] = useState<'all' | 'following'>('all');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [isMuted, setIsMuted] = useState(true);
  const [activeCommentsPost, setActiveCommentsPost] = useState<FeedPost | null>(null);
  const [comments, setComments] = useState<PostComment[]>([]);
  const [commentsLoading, setCommentsLoading] = useState(false);
  const [newComment, setNewComment] = useState('');
  const [likedComments, setLikedComments] = useState<Set<string>>(new Set());
  const [followingLoading, setFollowingLoading] = useState<Set<string>>(new Set());
  const [currentUserData, setCurrentUserData] = useState<any>(null);
  const [recentlySeenVideos, setRecentlySeenVideos] = useState<Set<string>>(new Set());
  const [autoplayEnabled, setAutoplayEnabled] = useState(true);
  const [dataSaverEnabled, setDataSaverEnabled] = useState(false);
  const [currentVideoIndex, setCurrentVideoIndex] = useState(0);
  const [likeBurst, setLikeBurst] = useState<{ postId: string; key: number } | null>(null);
  const likeBurstTimeoutRef = useRef<number | null>(null);

  const userId = currentUser?.uid || '';
  const currentPost = feed[currentVideoIndex] || null;

  const toCount = (value: unknown): number => {
    if (typeof value === 'number' && Number.isFinite(value)) return Math.max(0, Math.floor(value));
    if (Array.isArray(value)) return value.length;
    if (typeof value === 'string') {
      const parsed = Number(value);
      return Number.isFinite(parsed) ? Math.max(0, Math.floor(parsed)) : 0;
    }
    return 0;
  };

  useEffect(() => {
    const loadVideos = async () => {
      let hasInstantContent = false;
      try {
        setLoading(true);

        const warmCache = getCachedVideoFeed({ userId });
        if (warmCache.length > 0) {
          setAllVideos(warmCache);
          setFeed(warmCache);
          setLoading(false);
          hasInstantContent = true;
        }

        let followingSet = new Set<string>();
        if (userId) {
          const following = await getFollowing(userId);
          followingSet = new Set(following);
          setFollowingUsers(followingSet);
        }

        const videos = await fetchVideoFeed({
          userId,
          followingUsers: followingSet,
          recentlySeenVideos,
          forceRefresh: hasInstantContent
        });

        if (videos.length > 0) {
          setAllVideos(videos);
          setFeed(videos);

          if (userId) {
            const docPaths = videos.map((v) => v.docPath).filter(Boolean) as string[];
            getUserLikedPosts(userId, docPaths).then(setLikedPosts).catch(() => {});
          }

          const counts = new Map<string, number>();
          Promise.all(
            videos.map(async (video) => {
              if (video.userId) {
                const count = await getFollowerCount(video.userId);
                counts.set(video.userId, count);
              }
            })
          ).then(() => setFollowerCounts(counts)).catch(() => {});
        } else if (!hasInstantContent) {
          setError('Aucune vidéo disponible pour le moment');
        }
      } catch (e) {
        if (!hasInstantContent) {
          setError('Impossible de charger les vidéos');
        }
      } finally {
        if (!hasInstantContent) {
          setLoading(false);
        }
      }
    };

    void loadVideos();
  }, [userId]);

  useEffect(() => {
    const loadCurrentUser = async () => {
      if (!userId) return;
      try {
        const db = getFirestoreDb();
        const userDoc = await getDoc(doc(db, 'users', userId));
        if (userDoc.exists()) {
          setCurrentUserData(userDoc.data());
        }
      } catch {
        // ignore
      }
    };
    void loadCurrentUser();
  }, [userId]);

  useEffect(() => {
    if (activeTab === 'all') {
      setFeed(allVideos);
      return;
    }
    const filteredVideos = allVideos.filter((video) => followingUsers.has(video.userId));
    setFeed(filteredVideos);
  }, [activeTab, allVideos, followingUsers]);

  useEffect(() => {
    const applySettings = () => {
      const appSettings = loadAppSettings();
      setAutoplayEnabled(appSettings.autoplayVideos);
      setDataSaverEnabled(appSettings.dataSaver);
      if (appSettings.dataSaver) setIsMuted(true);
    };

    applySettings();
    window.addEventListener(SETTINGS_EVENT, applySettings as EventListener);
    window.addEventListener('storage', applySettings);

    return () => {
      window.removeEventListener(SETTINGS_EVENT, applySettings as EventListener);
      window.removeEventListener('storage', applySettings);
    };
  }, []);

  useEffect(() => {
    if (feed.length === 0) {
      setCurrentVideoIndex(0);
      return;
    }

    const boundedIndex = Math.min(currentVideoIndex, feed.length - 1);
    const current = feed[boundedIndex];
    if (current) {
      setRecentlySeenVideos((prev) => new Set(prev).add(current.id));
    }

    feed.forEach((_, index) => {
      const video = document.getElementById(`video-${index}`) as HTMLVideoElement | null;
      if (!video) return;
      if (index === boundedIndex && autoplayEnabled) {
        video.play().catch(() => {});
      } else {
        video.pause();
      }
    });
  }, [currentVideoIndex, feed, autoplayEnabled]);

  const getSportFromPost = (post: FeedPost): string => {
    if (post.hashtags && post.hashtags.length > 0) {
      const sportTags = ['Football', 'Basketball', 'Tennis', 'Volleyball', 'Cyclisme', 'Athlétisme', 'Natation'];
      const foundSport = post.hashtags.find((tag) => sportTags.some((sport) => tag.toLowerCase().includes(sport.toLowerCase())));
      if (foundSport) return foundSport;
    }
    return 'Talent';
  };

  const toggleMute = () => setIsMuted((prev) => !prev);

  const openAthleteProfile = (post: FeedPost) => {
    if (!post.userId) return;
    const preloadedVideos: PerformanceVideo[] = allVideos
      .filter((v) => v.userId === post.userId)
      .map((v) => ({
        id: v.id,
        userId: v.userId,
        userName: v.userName || 'Talent',
        userAvatar: v.userAvatar,
        videoUrl: v.url,
        thumbnailUrl: v.thumbnail,
        caption: v.caption,
        title: '',
        createdAt: v.createdAt,
        likes: toCount(v.likes),
        comments: toCount(v.comments),
        shares: toCount(v.shares),
        processed: true,
        format: 'mp4'
      }));

    navigate(`/athlete/${post.userId}`, {
      state: {
        prefillProfile: {
          uid: post.userId,
          email: '',
          displayName: post.userName || 'Athlète',
          type: UserType.ATHLETE,
          country: '',
          city: '',
          avatarUrl: post.userAvatar || '',
          sport: '',
          position: ''
        },
        preloadedVideos
      }
    });
  };

  const toggleLike = async (post: FeedPost) => {
    if (!userId) {
      alert('Veuillez vous connecter pour liker');
      return;
    }
    if (!post.docPath) return;

    const previousLikedPosts = new Set(likedPosts);
    const isLiked = likedPosts.has(post.docPath);
    const optimisticLikes = new Set(previousLikedPosts);
    if (isLiked) optimisticLikes.delete(post.docPath);
    else optimisticLikes.add(post.docPath);
    setLikedPosts(optimisticLikes);

    if (!isLiked) {
      if (likeBurstTimeoutRef.current !== null) {
        window.clearTimeout(likeBurstTimeoutRef.current);
      }
      setLikeBurst({ postId: post.id, key: Date.now() });
      likeBurstTimeoutRef.current = window.setTimeout(() => {
        setLikeBurst(null);
      }, 650);
    }

    const updateLikeCount = (p: FeedPost) =>
      p.id === post.id
        ? { ...p, likes: isLiked ? Math.max(0, toCount(p.likes) - 1) : toCount(p.likes) + 1 }
        : p;

    setFeed((prev) => prev.map(updateLikeCount));
    setAllVideos((prev) => prev.map(updateLikeCount));

    try {
      await toggleLikePost(post.docPath, userId, isLiked);
    } catch {
      setLikedPosts(previousLikedPosts);
      const rollbackLikeCount = (p: FeedPost) =>
        p.id === post.id
          ? { ...p, likes: isLiked ? toCount(p.likes) + 1 : Math.max(0, toCount(p.likes) - 1) }
          : p;
      setFeed((prev) => prev.map(rollbackLikeCount));
      setAllVideos((prev) => prev.map(rollbackLikeCount));
    }
  };

  useEffect(() => {
    return () => {
      if (likeBurstTimeoutRef.current !== null) {
        window.clearTimeout(likeBurstTimeoutRef.current);
      }
    };
  }, []);

  const handleFollowToggle = async (post: FeedPost) => {
    if (!userId) {
      alert('Veuillez vous connecter pour suivre des athlètes');
      return;
    }

    setFollowingLoading((prev) => new Set(prev).add(post.userId));
    const isCurrentlyFollowing = followingUsers.has(post.userId);

    try {
      if (isCurrentlyFollowing) {
        setFollowingUsers((prev) => {
          const copy = new Set(prev);
          copy.delete(post.userId);
          return copy;
        });
        setFollowerCounts((prev) => {
          const copy = new Map(prev);
          copy.set(post.userId, Math.max(0, (copy.get(post.userId) || 0) - 1));
          return copy;
        });
        await unfollowAthlete(userId, post.userId);
      } else {
        setFollowingUsers((prev) => new Set(prev).add(post.userId));
        setFollowerCounts((prev) => {
          const copy = new Map(prev);
          copy.set(post.userId, (copy.get(post.userId) || 0) + 1);
          return copy;
        });
        await followAthlete(userId, post.userId);
      }
    } catch {
      // rollback simple
      if (isCurrentlyFollowing) {
        setFollowingUsers((prev) => new Set(prev).add(post.userId));
      } else {
        setFollowingUsers((prev) => {
          const copy = new Set(prev);
          copy.delete(post.userId);
          return copy;
        });
      }
      alert('Erreur lors de la mise à jour du suivi');
    } finally {
      setFollowingLoading((prev) => {
        const copy = new Set(prev);
        copy.delete(post.userId);
        return copy;
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
    if (!activeCommentsPost || !newComment.trim() || !activeCommentsPost.docPath) return;

    const optimistic: PostComment = {
      id: `local-${Date.now()}`,
      userId: userId || 'anonymous',
      userName: currentUserData?.displayName || currentUser?.displayName || 'Utilisateur',
      userAvatar: currentUserData?.avatarUrl || currentUser?.photoURL || '/assets/images/app_launcher_icon.png',
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

      setFeed((prev) => prev.map((p) => (p.id === activeCommentsPost.id ? { ...p, comments: p.comments + 1 } : p)));
    } catch {
      setComments((prev) => prev.filter((c) => c.id !== optimistic.id));
      alert("Impossible d'envoyer le commentaire pour le moment.");
    }
  };

  const handleLikeComment = async (comment: PostComment) => {
    if (!activeCommentsPost?.docPath || likedComments.has(comment.id)) return;

    setLikedComments((prev) => new Set(prev).add(comment.id));
    setComments((prev) => prev.map((c) => (c.id === comment.id ? { ...c, likes: c.likes + 1 } : c)));

    try {
      await likeComment({ docPath: activeCommentsPost.docPath, commentId: comment.id });
    } catch {
      setLikedComments((prev) => {
        const copy = new Set(prev);
        copy.delete(comment.id);
        return copy;
      });
      setComments((prev) => prev.map((c) => (c.id === comment.id ? { ...c, likes: Math.max(0, c.likes - 1) } : c)));
    }
  };

  const handleShare = async (post: FeedPost) => {
    try {
      await shareVideoPost(post.id, post.userName, post.caption, post.url, post.thumbnail, post.hashtags || []);
      setFeed((prev) => prev.map((p) => (p.id === post.id ? { ...p, shares: p.shares + 1 } : p)));
    } catch {
      // ignore
    }
  };

  return (
    <div className="w-full h-screen flex flex-col bg-[#050505] overflow-hidden">
      <header className="fixed top-0 left-0 right-0 z-50 px-4 py-3 flex justify-between items-center pointer-events-none bg-black/40 backdrop-blur-md border-b border-white/5">
        <div className="flex gap-2 pointer-events-auto bg-black/40 rounded-full px-1 py-1 border border-white/10 backdrop-blur-md">
          <button
            onClick={() => setActiveTab('all')}
            className={`text-xs md:text-sm font-readex font-semibold tracking-tight px-2 md:px-3 py-1 rounded-full transition-all ${
              activeTab === 'all' ? 'text-white bg-[#208050]' : 'text-white/40'
            }`}
          >
            #ChooseTalent
          </button>
          <button
            onClick={() => setActiveTab('following')}
            className={`text-xs md:text-sm font-readex font-semibold tracking-tight px-2 md:px-3 py-1 rounded-full transition-all ${
              activeTab === 'following' ? 'text-white bg-[#208050]' : 'text-white/40'
            }`}
          >
            Abonnements
          </button>
        </div>
        <div className="flex gap-2 pointer-events-auto">
          <button
            onClick={() => navigate('/notifications')}
            className="p-2 bg-black/20 backdrop-blur-md rounded-full border border-white/10 text-white"
          >
            <Bell size={18} />
          </button>
          <div className="w-9 h-9 rounded-full border-2 border-[#19DB8A] overflow-hidden bg-white/10">
            <img
              src={currentUserData?.avatarUrl || currentUser?.photoURL || '/assets/images/app_launcher_icon.png'}
              alt="Me"
              className="w-full h-full object-cover"
            />
          </div>
        </div>
      </header>

      <div
        className="flex-1 w-full overflow-y-scroll snap-y snap-mandatory custom-scrollbar pt-16 pb-20"
        onScroll={(e) => {
          const container = e.currentTarget;
          const nextIndex = Math.round(container.scrollTop / container.clientHeight);
          if (nextIndex !== currentVideoIndex) {
            setCurrentVideoIndex(nextIndex);
          }
        }}
      >
        {loading && (
          <div className="w-full h-screen flex flex-col items-center justify-center bg-[#050505]">
            <div className="relative w-32 h-32 mb-6 rounded-full overflow-hidden bg-white/5 border-4 border-[#19DB8A]/30 shadow-2xl">
              <img src="/assets/images/app_launcher_icon.png" alt="Choose Me" className="w-full h-full object-cover animate-pulse" />
            </div>
            <p className="text-white/60 text-sm">Chargement des vidéos...</p>
          </div>
        )}

        {!loading && error && (
          <div className="w-full h-screen flex flex-col items-center justify-center p-6">
            <div className="text-center">
              <div className="w-20 h-20 rounded-full bg-white/5 flex items-center justify-center mx-auto mb-4">
                <span className="text-4xl">📹</span>
              </div>
              <p className="text-white/60 text-sm mb-2">{error}</p>
              <p className="text-white/40 text-xs">Vérifiez votre connexion ou réessayez plus tard</p>
            </div>
          </div>
        )}

        {!loading && !error && feed.length === 0 && (
          <div className="w-full h-screen flex flex-col items-center justify-center p-6">
            <div className="text-center">
              <div className="w-20 h-20 rounded-full bg-white/5 flex items-center justify-center mx-auto mb-4">
                <span className="text-4xl">🎬</span>
              </div>
              <p className="text-white/60 text-sm mb-2">{activeTab === 'following' ? 'Aucune vidéo de vos abonnements' : 'Aucune vidéo disponible'}</p>
              <p className="text-white/40 text-xs">
                {activeTab === 'following' ? 'Suivez des talents pour voir leurs vidéos ici' : 'Les vidéos apparaîtront ici bientôt'}
              </p>
            </div>
          </div>
        )}

        {!loading && !error &&
          feed.map((post, index) => (
            <div key={`${post.id}-${post.docPath}-${index}`} className="relative w-full h-screen snap-start overflow-hidden flex-shrink-0">
              <video
                id={`video-${index}`}
                src={post.url}
                poster={post.thumbnail || '/assets/images/app_launcher_icon.png'}
                className="w-full h-full object-cover"
                autoPlay={autoplayEnabled && index === 0}
                muted={isMuted}
                loop
                playsInline
                preload={dataSaverEnabled ? 'none' : index < 2 ? 'auto' : 'metadata'}
              />
              <div className="absolute inset-0 bg-gradient-to-b from-transparent via-transparent to-black/40 pointer-events-none" />
            </div>
          ))}
      </div>

      {!loading && !error && currentPost && (
        <>
          <div className="absolute right-0 bottom-32 flex flex-col gap-3 items-center z-20">
            <button onClick={toggleMute} className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-full bg-black/30 backdrop-blur-md text-white hover:text-[#19DB8A] transition-all flex items-center justify-center">
                {isMuted ? <IconVolumeMuted size={24} /> : <IconVolume size={24} />}
              </div>
            </button>

            <button
              onClick={() => handleFollowToggle(currentPost)}
              disabled={followingLoading.has(currentPost.userId)}
              className="flex flex-col items-center"
            >
              <div
                className={`w-12 h-12 rounded-full backdrop-blur-md transition-all flex items-center justify-center ${
                  followingUsers.has(currentPost.userId)
                    ? 'bg-[#19DB8A]/20 text-[#19DB8A]'
                    : 'bg-black/30 text-white hover:bg-[#19DB8A]/20 hover:text-[#19DB8A]'
                } ${followingLoading.has(currentPost.userId) ? 'opacity-50' : ''}`}
              >
                {followingUsers.has(currentPost.userId) ? <UserCheck size={24} /> : <UserPlus size={24} />}
              </div>
              <span className="text-white text-[11px] font-bold mt-1 min-h-[16px]">{toCount(followerCounts.get(currentPost.userId))}</span>
            </button>

            <div className="flex flex-col items-center">
              <button onClick={() => openAthleteProfile(currentPost)} className="w-12 h-12 rounded-full border-2 border-white overflow-hidden shadow-lg">
                <img src={currentPost.userAvatar || '/assets/images/app_launcher_icon.png'} alt={currentPost.userName} className="w-full h-full object-cover" />
              </button>
              <div className="bg-[#19DB8A] rounded-full p-0.5 -mt-2 relative z-10 border-2 border-black">
                <PlusCircle size={10} className="text-white" />
              </div>
            </div>

            <button onClick={() => toggleLike(currentPost)} className="flex flex-col items-center">
              <div
                className={`relative overflow-visible w-12 h-12 rounded-full backdrop-blur-md transition-all flex items-center justify-center ${
                  currentPost.docPath && likedPosts.has(currentPost.docPath)
                    ? 'bg-[#19DB8A]/20 border border-[#19DB8A]/50 text-[#19DB8A] shadow-[0_0_20px_rgba(25,219,138,0.45)] scale-110'
                    : 'bg-black/30 text-white hover:text-[#19DB8A]'
                }`}
              >
                {likeBurst?.postId === currentPost.id && (
                  <span key={likeBurst.key} className="pointer-events-none absolute inset-0 flex items-center justify-center">
                    <span className="absolute w-16 h-16 rounded-full bg-[#19DB8A]/25 animate-ping" />
                    <span
                      className="absolute w-20 h-20 rounded-full border border-[#19DB8A]/70 animate-ping"
                      style={{ animationDelay: '120ms' }}
                    />
                    <span className="absolute -top-2 text-[#19DB8A] text-lg font-bold animate-bounce">+1</span>
                  </span>
                )}
                <IconLike size={24} />
              </div>
              <span className="text-white text-[11px] font-bold mt-1 min-h-[16px]">{toCount(currentPost.likes)}</span>
            </button>

            <button className="flex flex-col items-center" onClick={() => openComments(currentPost)}>
              <div className="w-12 h-12 rounded-full bg-black/30 backdrop-blur-md text-white hover:text-[#19DB8A] transition-all flex items-center justify-center">
                <IconComment size={24} />
              </div>
              <span className="text-white text-[11px] font-bold mt-1 min-h-[16px]">{toCount(currentPost.comments)}</span>
            </button>

            <button onClick={() => handleShare(currentPost)} className="flex flex-col items-center">
              <div className="w-12 h-12 rounded-full bg-black/30 backdrop-blur-md text-white hover:text-[#19DB8A] transition-all flex items-center justify-center">
                <IconShare size={24} />
              </div>
              <span className="text-white text-[11px] font-bold mt-1 min-h-[16px]">{toCount(currentPost.shares)}</span>
            </button>
          </div>

          <div className="absolute left-4 right-20 bottom-32 z-20">
            <button onClick={() => openAthleteProfile(currentPost)} className="text-white font-bold text-sm mb-1 flex items-center gap-2 line-clamp-1">
              @{currentPost.userName}
              <span className="bg-[#208050] text-[8px] px-1.5 py-0.5 rounded-full uppercase tracking-widest flex-shrink-0">{getSportFromPost(currentPost)}</span>
            </button>
            <p className="text-white/90 text-xs leading-tight line-clamp-2 mb-2">{currentPost.caption}</p>
            {currentPost.hashtags && currentPost.hashtags.length > 0 && (
              <div className="flex gap-1 flex-wrap">
                {currentPost.hashtags.slice(0, 3).map((tag) => (
                  <span key={tag} className="text-[#19DB8A] text-[10px] font-medium">
                    #{tag.replace(/^#/, '')}
                  </span>
                ))}
              </div>
            )}
          </div>
        </>
      )}

      {activeCommentsPost && (
        <div className="fixed inset-0 z-[80] bg-black/60 flex items-end justify-center">
          <div className="w-full max-w-md bg-[#050505] rounded-t-3xl p-4 border-t border-white/10 mb-20">
            <div className="flex items-center justify-between mb-3">
              <h4 className="text-white font-semibold text-sm">Commentaires sur la vidéo de @{activeCommentsPost.userName}</h4>
              <button onClick={closeComments} className="text-white/60 text-xs px-2 py-1 rounded-full border border-white/20">
                Fermer
              </button>
            </div>

            <div className="h-36 overflow-y-auto custom-scrollbar space-y-3 mb-4">
              {commentsLoading && <p className="text-white/50 text-xs">Chargement des commentaires...</p>}
              {!commentsLoading && comments.length === 0 && (
                <p className="text-white/40 text-xs">Pas encore de commentaires. Soyez le premier à réagir !</p>
              )}

              {comments.map((c) => (
                <div key={c.id} className="flex items-start gap-2">
                  <div className="w-8 h-8 rounded-full overflow-hidden bg-white/10 flex-shrink-0">
                    {c.userAvatar ? (
                      <img src={c.userAvatar} className="w-full h-full object-cover" />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-xs text-white/70">{c.userName.charAt(0).toUpperCase()}</div>
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
                          likedComments.has(c.id) ? 'border-[#19DB8A] text-[#19DB8A]' : 'border-white/20 text-white/60'
                        } text-[10px]`}
                      >
                        <Heart size={12} className={likedComments.has(c.id) ? 'fill-current' : ''} />
                        <span>{c.likes}</span>
                      </button>
                    </div>
                    <p className="text-white/80 text-xs mt-0.5">{c.text}</p>
                  </div>
                </div>
              ))}
            </div>

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

const PlusCircle = ({ size, className }: any) => (
  <svg
    width={size}
    height={size}
    viewBox="0 0 24 24"
    fill="none"
    stroke="currentColor"
    strokeWidth="3"
    strokeLinecap="round"
    strokeLinejoin="round"
    className={className}
  >
    <line x1="12" y1="5" x2="12" y2="19"></line>
    <line x1="5" y1="12" x2="19" y2="12"></line>
  </svg>
);

export default HomeChoosePage;
