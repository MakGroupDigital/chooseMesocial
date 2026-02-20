import React, { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Search, Filter, Star, MapPin, ChevronRight, Newspaper, TrendingUp, Link as LinkIcon, Heart, MessageCircle, Share2, Eye, X } from 'lucide-react';
import { UserType, NewsArticle, PostComment } from '../../types';
import { addReportageComment, fetchReportageComments, fetchReportages, PRESS_ARTICLE_CATEGORIES, type PressArticleCategory, type ReportageItem, updateReportageMetric } from '../../services/reportageService';
import { fetchTalentExplorerItems, type TalentExplorerItem } from '../../services/talentService';
import { SPORTS_POSITIONS } from '../../utils/sportsData';
import { useAuth } from '../../services/firebase';

// NOTE: on ne montre plus les news statiques, seulement les vrais reportages Firestore.
const MOCK_NEWS: NewsArticle[] = [];
void MOCK_NEWS;

const ALL_SPORT_FILTERS: string[] = [
  ...Object.keys(SPORTS_POSITIONS),
  'Lutte',
  'MMA',
  'Judo',
  'Karaté',
  'Taekwondo',
  'Rugby',
  'Natation',
  'Gymnastique',
  'Haltérophilie',
  'Escrime',
  'Badminton',
  'Tennis de table',
  'Baseball',
  'Cricket'
];

const normalizeSport = (value: string): string =>
  String(value || '')
    .trim()
    .toLowerCase()
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '');

const ARTICLE_CATEGORIES = ['Tout', ...PRESS_ARTICLE_CATEGORIES] as const;
type ArticleCategory = typeof ARTICLE_CATEGORIES[number];

const ExplorerPage: React.FC<{ userType: UserType }> = ({ userType }) => {
  const { currentUser } = useAuth();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedSport, setSelectedSport] = useState('Tous');
  const [popularOnly, setPopularOnly] = useState(false);
  const [selectedArticleCategory, setSelectedArticleCategory] = useState<ArticleCategory>('Tout');
  const [reportages, setReportages] = useState<ReportageItem[]>([]);
  const [loadingReportages, setLoadingReportages] = useState(false);
  const [talents, setTalents] = useState<TalentExplorerItem[]>([]);
  const [loadingTalents, setLoadingTalents] = useState(false);
  const [likedIds, setLikedIds] = useState<Set<string>>(new Set());
  const [activeCommentsArticle, setActiveCommentsArticle] = useState<ReportageItem | null>(null);
  const [comments, setComments] = useState<PostComment[]>([]);
  const [commentsLoading, setCommentsLoading] = useState(false);
  const [newComment, setNewComment] = useState('');
  const isScout = userType === UserType.RECRUITER || userType === UserType.CLUB;
  const navigate = useNavigate();
  const likeStorageKey = `chooseme:reportageLikes:${currentUser?.uid || 'guest'}`;

  useEffect(() => {
    try {
      const raw = localStorage.getItem(likeStorageKey);
      if (!raw) {
        setLikedIds(new Set());
        return;
      }
      const parsed = JSON.parse(raw) as string[];
      setLikedIds(new Set(Array.isArray(parsed) ? parsed : []));
    } catch {
      setLikedIds(new Set());
    }
  }, [likeStorageKey]);

  const persistLikes = (ids: Set<string>) => {
    setLikedIds(ids);
    localStorage.setItem(likeStorageKey, JSON.stringify(Array.from(ids)));
  };

  useEffect(() => {
    const load = async () => {
      if (!isScout) {
        setLoadingReportages(true);
        const items = await fetchReportages();
        setReportages(items);
        setLoadingReportages(false);
        return;
      }

      setLoadingTalents(true);
      const items = await fetchTalentExplorerItems();
      setTalents(items);
      setLoadingTalents(false);
    };

    void load();
  }, [isScout]);

  const normalizedSearch = searchQuery.trim().toLowerCase();
  const extraSportsFromData = Array.from(
    new Set(talents.map((talent) => String(talent.sport || '').trim()).filter(Boolean))
  ).filter((sport) => !ALL_SPORT_FILTERS.some((baseSport) => normalizeSport(baseSport) === normalizeSport(sport)));
  const availableSports = [...ALL_SPORT_FILTERS, ...extraSportsFromData];

  const filteredTalents = talents.filter((talent) => {
    if (
      selectedSport !== 'Tous' &&
      normalizeSport(talent.sport || '') !== normalizeSport(selectedSport)
    ) {
      return false;
    }
    if (popularOnly && talent.totalLikes < 2) return false;

    if (!normalizedSearch) return true;
    return [
      talent.displayName,
      talent.sport,
      talent.position,
      talent.country,
      talent.city
    ]
      .join(' ')
      .toLowerCase()
      .includes(normalizedSearch);
  });

  const inferArticleCategory = (reportage: ReportageItem): ArticleCategory =>
    (reportage.category && PRESS_ARTICLE_CATEGORIES.includes(reportage.category as PressArticleCategory)
      ? reportage.category
      : 'Tout');

  const filteredReportages = reportages.filter((reportage) => {
    if (selectedArticleCategory !== 'Tout' && inferArticleCategory(reportage) !== selectedArticleCategory) {
      return false;
    }
    if (!normalizedSearch) return true;
    return `${reportage.title} ${reportage.detail} ${reportage.reporter}`
      .toLowerCase()
      .includes(normalizedSearch);
  });
  const reportagesWithMedia = useMemo(
    () =>
      filteredReportages.map((reportage) => {
        const medias = reportage.medias && reportage.medias.length > 0
          ? reportage.medias
          : [{ type: reportage.mediaType, url: reportage.mediaUrl }];
        return { ...reportage, medias };
      }),
    [filteredReportages]
  );

  const applyMetric = (id: string, metric: 'likes' | 'comments' | 'shares' | 'views', delta: number) => {
    setReportages((prev) =>
      prev.map((item) =>
        item.id === id
          ? {
              ...item,
              [metric]: Math.max(0, Number((item as any)[metric] || 0) + delta)
            }
          : item
      )
    );
  };

  const handleLike = async (id: string) => {
    const alreadyLiked = likedIds.has(id);
    const delta = alreadyLiked ? -1 : 1;
    const next = new Set(likedIds);
    if (alreadyLiked) next.delete(id);
    else next.add(id);
    persistLikes(next);
    applyMetric(id, 'likes', delta);
    try {
      await updateReportageMetric(id, 'likes', delta);
    } catch {
      // rollback
      const rollback = new Set(next);
      if (alreadyLiked) rollback.add(id);
      else rollback.delete(id);
      persistLikes(rollback);
      applyMetric(id, 'likes', -delta);
    }
  };

  const handleShare = async (item: ReportageItem) => {
    const url = `${window.location.origin}/#/explorer/reportage/${item.id}`;
    const text = `${item.title} - ${item.reporter}`;
    try {
      if (navigator.share) {
        await navigator.share({ title: item.title, text, url });
      } else if (navigator.clipboard) {
        await navigator.clipboard.writeText(url);
      }
      applyMetric(item.id, 'shares', 1);
      await updateReportageMetric(item.id, 'shares', 1);
    } catch {
      // ignore user cancel / errors
    }
  };

  const handleComment = async (item: ReportageItem) => {
    if (!currentUser?.uid) {
      navigate('/login');
      return;
    }
    setActiveCommentsArticle(item);
    setComments([]);
    setCommentsLoading(true);
    try {
      const list = await fetchReportageComments(item.id);
      setComments(list);
    } finally {
      setCommentsLoading(false);
    }
  };

  const closeComments = () => {
    setActiveCommentsArticle(null);
    setComments([]);
    setNewComment('');
  };

  const handleSendComment = async () => {
    if (!activeCommentsArticle || !currentUser?.uid || !newComment.trim()) return;

    const text = newComment.trim();
    const optimistic: PostComment = {
      id: `tmp-${Date.now()}`,
      userId: currentUser.uid,
      userName: currentUser.displayName || 'Utilisateur',
      userAvatar: currentUser.photoURL || undefined,
      text,
      createdAt: 'à l’instant',
      likes: 0
    };

    setComments((prev) => [...prev, optimistic]);
    setNewComment('');
    applyMetric(activeCommentsArticle.id, 'comments', 1);

    try {
      await addReportageComment(activeCommentsArticle.id, {
        userId: currentUser.uid,
        userName: currentUser.displayName || 'Utilisateur',
        userAvatar: currentUser.photoURL || '',
        text
      });
      await updateReportageMetric(activeCommentsArticle.id, 'comments', 1);
    } catch {
      setComments((prev) => prev.filter((comment) => comment.id !== optimistic.id));
      applyMetric(activeCommentsArticle.id, 'comments', -1);
      alert('Impossible d’envoyer le commentaire.');
    }
  };

  const openArticle = async (item: ReportageItem) => {
    applyMetric(item.id, 'views', 1);
    void updateReportageMetric(item.id, 'views', 1);
    navigate(`/explorer/reportage/${item.id}`, { state: { reportage: item } });
  };

  return (
    <div className="p-6 pb-32 min-h-full bg-[#050505]">
      <header className="mb-6 pt-4">
        <h1 className="text-3xl font-readex font-bold">
          {isScout ? 'Recrutement' : 'Actualités'}
        </h1>
        <p className="text-white/40 mt-1">
          {isScout ? 'Trouvez les meilleurs talents sportifs' : 'Toute l\'actualité du sport africain'}
        </p>
      </header>

      {/* Search Bar */}
      <div className="relative mb-8">
        <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-white/30" size={20} />
        <input
          type="text"
          placeholder={isScout ? 'Nom, poste, pays...' : 'Rechercher un article...'}
          className="w-full bg-[#0A0A0A] border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white focus:border-[#19DB8A] transition-all"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
        />
        <button className="absolute right-3 top-1/2 -translate-y-1/2 p-2 bg-[#208050] rounded-xl">
          <Filter size={18} />
        </button>
      </div>

      {isScout ? (
        /* TALENT SEARCH VIEW */
        <div className="space-y-4">
          <div className="flex overflow-x-auto gap-2 pb-1 custom-scrollbar">
            <button
              onClick={() => setSelectedSport('Tous')}
              className={`px-3 py-1.5 rounded-full text-[11px] font-bold whitespace-nowrap border ${
                selectedSport === 'Tous'
                  ? 'bg-[#19DB8A] border-[#19DB8A] text-black'
                  : 'bg-transparent border-white/10 text-white/55'
              }`}
            >
              Tous
            </button>
            {availableSports.map((sport) => (
              <button
                key={sport}
                onClick={() => setSelectedSport(sport)}
                className={`px-3 py-1.5 rounded-full text-[11px] font-bold whitespace-nowrap border ${
                  selectedSport === sport
                    ? 'bg-[#19DB8A] border-[#19DB8A] text-black'
                    : 'bg-transparent border-white/10 text-white/55'
                }`}
              >
                {sport}
              </button>
            ))}
            <button
              onClick={() => setPopularOnly((prev) => !prev)}
              className={`px-3 py-1.5 rounded-full text-[11px] font-bold whitespace-nowrap border ${
                popularOnly
                  ? 'bg-[#FF8A3C] border-[#FF8A3C] text-black'
                  : 'bg-transparent border-white/10 text-white/55'
              }`}
            >
              Populaire
            </button>
          </div>

          <div className="flex justify-between items-center mb-2">
            <h2 className="font-bold flex items-center gap-2">
              <TrendingUp size={18} className="text-[#19DB8A]" /> Talents Emergents
            </h2>
            <span className="text-[#19DB8A] text-xs font-bold">{filteredTalents.length} TALENTS</span>
          </div>

          {loadingTalents && (
            <div className="py-8 text-center text-white/40 text-sm">Chargement des talents...</div>
          )}

          {!loadingTalents && filteredTalents.length === 0 && (
            <div className="py-8 text-center text-white/40 text-sm">
              Aucun talent trouvé pour cette recherche.
            </div>
          )}

          {!loadingTalents &&
            filteredTalents.map((talent) => (
              <div
                key={talent.id}
                className="bg-[#0A0A0A] border border-white/5 p-4 rounded-3xl flex items-center gap-4 active:scale-[0.98] transition-all cursor-pointer"
                onClick={() => navigate(`/athlete/${talent.id}`)}
              >
                <img
                  src={talent.avatarUrl}
                  className="w-20 h-20 rounded-2xl object-cover"
                  onError={(e) => {
                    (e.currentTarget as HTMLImageElement).src = '/assets/images/app_launcher_icon.png';
                  }}
                />
                <div className="flex-1">
                  <h3 className="font-bold">
                    {talent.displayName}
                    <span className="bg-white/5 text-[8px] px-1 py-0.5 rounded ml-1 text-white/40 uppercase">
                      {talent.sport}
                    </span>
                  </h3>
                  <p className="text-white/40 text-xs mt-0.5">
                    {talent.position}
                    {talent.height ? ` • ${(talent.height / 100).toFixed(2)}m` : ''}
                  </p>
                  <div className="flex items-center gap-3 mt-2">
                    <div className="flex items-center gap-1 text-[#FF8A3C] text-[10px] font-bold">
                      <Star size={12} fill="currentColor" /> {talent.rating.toFixed(1)}
                    </div>
                    <div className="flex items-center gap-1 text-white/30 text-[10px]">
                      <MapPin size={10} /> {talent.country || 'N/A'}
                    </div>
                    <div className="text-[#19DB8A] text-[10px] font-bold">{talent.totalLikes} likes</div>
                  </div>
                </div>
                <ChevronRight className="text-white/20" />
              </div>
            ))}
        </div>
      ) : (
        /* NEWS VIEW */
        <div className="space-y-6">
          {/* Filtres catégories */}
          <div className="flex overflow-x-auto gap-3 pb-2 -mx-2 px-2 custom-scrollbar">
            {ARTICLE_CATEGORIES.map((cat) => (
              <button
                key={cat}
                onClick={() => setSelectedArticleCategory(cat)}
                className={`px-4 py-2 rounded-full text-xs font-bold whitespace-nowrap border ${
                  cat === selectedArticleCategory
                    ? 'bg-[#19DB8A] border-[#19DB8A] text-black'
                    : 'bg-transparent border-white/10 text-white/40'
                }`}
              >
                {cat}
              </button>
            ))}
          </div>

          {/* FLUX ACTUS (style feed) */}
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <h2 className="flex items-center gap-2 text-sm font-bold text-white">
                <Newspaper size={16} className="text-[#19DB8A]" />
                Articles presse
              </h2>
              {loadingReportages && <span className="text-white/40 text-[10px]">Chargement...</span>}
            </div>
            {!loadingReportages && filteredReportages.length === 0 && (
              <p className="text-white/30 text-xs">Aucun reportage trouvé pour ce filtre.</p>
            )}
            <div className="space-y-0">
              {reportagesWithMedia.map((r) => (
                <article key={r.id} className="py-4 border-b border-white/10">
                  <div className="flex gap-3">
                    <button
                      onClick={() => r.authorUserId && navigate(`/athlete/${r.authorUserId}`)}
                      className="w-11 h-11 rounded-full overflow-hidden border border-white/10 shrink-0"
                    >
                      <img
                        src={r.reporterAvatar || '/assets/images/app_launcher_icon.png'}
                        alt={r.reporter}
                        className="w-full h-full object-cover"
                      />
                    </button>

                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <button
                          className="font-bold text-white text-sm hover:underline"
                          onClick={() => r.authorUserId && navigate(`/athlete/${r.authorUserId}`)}
                        >
                          {r.reporter}
                        </button>
                        <span className="text-white/35 text-xs">• {r.date || 'Aujourd\'hui'}</span>
                        {r.category && (
                          <span className="text-[10px] px-2 py-0.5 rounded-full bg-[#19DB8A]/15 text-[#19DB8A] border border-[#19DB8A]/30">
                            {r.category}
                          </span>
                        )}
                      </div>

                      {r.pressWebsite && (
                        <a
                          href={r.pressWebsite.startsWith('http') ? r.pressWebsite : `https://${r.pressWebsite}`}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="mt-1 inline-flex items-center gap-1 text-[#19DB8A] text-xs hover:underline"
                        >
                          <LinkIcon size={12} />
                          {r.pressWebsite}
                        </a>
                      )}

                      <button
                        className="w-full text-left mt-2"
                        onClick={() => void openArticle(r)}
                      >
                        <p className="text-white font-semibold text-[15px] leading-5">{r.title}</p>
                        {r.detail && <p className="text-white/70 text-sm mt-1 whitespace-pre-wrap line-clamp-2">{r.detail}</p>}
                      </button>

                      <div
                        className={`mt-3 grid gap-2 rounded-2xl overflow-hidden ${
                          r.medias.length === 1 ? 'grid-cols-1' : 'grid-cols-2'
                        }`}
                      >
                        {r.medias.slice(0, 4).map((media, idx) => (
                          <button
                            key={`${r.id}-${idx}`}
                            className={`relative bg-black ${
                              r.medias.length === 3 && idx === 0 ? 'row-span-2 min-h-[220px]' : 'min-h-[120px]'
                            }`}
                            onClick={() => void openArticle(r)}
                          >
                            {media.type === 'video' ? (
                              <video
                                src={media.url}
                                className="w-full h-full object-cover"
                                muted
                                playsInline
                                preload="metadata"
                              />
                            ) : (
                              <img src={media.url} alt={r.title} className="w-full h-full object-cover" loading="lazy" />
                            )}
                          </button>
                        ))}
                      </div>

                      <div className="mt-3 flex items-center gap-5 text-white/60">
                        <button onClick={() => void handleLike(r.id)} className="flex items-center gap-1.5 text-xs">
                          <Heart size={15} className={likedIds.has(r.id) ? 'text-[#19DB8A] fill-[#19DB8A]' : ''} />
                          <span>{r.likes || 0}</span>
                        </button>
                        <button onClick={() => void handleComment(r)} className="flex items-center gap-1.5 text-xs">
                          <MessageCircle size={15} />
                          <span>{r.comments || 0}</span>
                        </button>
                        <button onClick={() => void handleShare(r)} className="flex items-center gap-1.5 text-xs">
                          <Share2 size={15} />
                          <span>{r.shares || 0}</span>
                        </button>
                        <button onClick={() => void openArticle(r)} className="flex items-center gap-1.5 text-xs">
                          <Eye size={15} />
                          <span>{r.views || 0}</span>
                        </button>
                      </div>
                    </div>
                  </div>
                </article>
              ))}
            </div>
          </div>

          {/* SECTION ARTICLES / NEWS (désactivée – on affiche uniquement les vrais reportages Firestore) */}
        </div>
      )}
      {activeCommentsArticle && (
        <div className="fixed inset-0 z-[90] bg-black/70 flex items-end justify-center">
          <div className="w-full max-w-md bg-[#050505] rounded-t-3xl p-4 border-t border-white/10 mb-20">
            <div className="flex items-center justify-between mb-3">
              <h4 className="text-white font-semibold text-sm">
                Commentaires sur "{activeCommentsArticle.title}"
              </h4>
              <button
                onClick={closeComments}
                className="w-8 h-8 rounded-full border border-white/20 text-white/70 flex items-center justify-center"
              >
                <X size={14} />
              </button>
            </div>

            <div className="h-48 overflow-y-auto custom-scrollbar space-y-3 mb-4">
              {commentsLoading && <p className="text-white/50 text-xs">Chargement des commentaires...</p>}
              {!commentsLoading && comments.length === 0 && (
                <p className="text-white/40 text-xs">Pas encore de commentaires. Soyez le premier à réagir.</p>
              )}

              {comments.map((comment) => (
                <div key={comment.id} className="flex items-start gap-2">
                  <div className="w-8 h-8 rounded-full overflow-hidden bg-white/10 flex-shrink-0">
                    {comment.userAvatar ? (
                      <img src={comment.userAvatar} className="w-full h-full object-cover" />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center text-xs text-white/70">
                        {comment.userName.charAt(0).toUpperCase()}
                      </div>
                    )}
                  </div>
                  <div className="flex-1">
                    <div className="flex items-center justify-between">
                      <span className="text-white text-xs font-semibold">@{comment.userName}</span>
                      <span className="text-white/30 text-[10px]">{comment.createdAt}</span>
                    </div>
                    <p className="text-white/80 text-xs mt-0.5">{comment.text}</p>
                  </div>
                </div>
              ))}
            </div>

            <div className="flex items-center gap-2">
              <input
                type="text"
                value={newComment}
                onChange={(e) => setNewComment(e.target.value)}
                placeholder="Écrire un commentaire..."
                className="flex-1 bg-black/40 border border-white/15 rounded-full px-3 py-2 text-xs text-white outline-none"
              />
              <button
                onClick={handleSendComment}
                disabled={!newComment.trim()}
                className="px-3 py-2 bg-[#19DB8A] rounded-full text-xs font-semibold text-black disabled:opacity-40"
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

export default ExplorerPage;
