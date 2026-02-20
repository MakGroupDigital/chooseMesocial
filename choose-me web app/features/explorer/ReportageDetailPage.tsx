import React, { useEffect, useState } from 'react';
import { useLocation, useNavigate, useParams } from 'react-router-dom';
import { ArrowLeft, Share2, Link as LinkIcon, X } from 'lucide-react';
import { fetchReportages, type ReportageItem } from '../../services/reportageService';
import CustomVideoPlayer from '../../components/CustomVideoPlayer';

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
  const [previewOpen, setPreviewOpen] = useState(false);
  const [previewStartIndex, setPreviewStartIndex] = useState(0);

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

  const handleShare = () => {
    if (!item) return;
    const url = `${window.location.origin}/#/explorer/reportage/${item.id}`;
    const text = `${item.title} - ${item.reporter}`;

    if (navigator.share) {
      navigator
        .share({
          title: item.title,
          text,
          url
        })
        .catch(() => {});
    } else if (navigator.clipboard) {
      navigator.clipboard.writeText(url).then(() => {
        alert('Lien du reportage copié dans le presse-papiers.');
      });
    } else {
      alert(url);
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

  const medias = item.medias.length > 0 ? item.medias : [{ type: item.mediaType, url: item.mediaUrl }];
  const openPreview = (index: number) => {
    setPreviewStartIndex(index);
    setPreviewOpen(true);
    requestAnimationFrame(() => {
      const el = document.getElementById(`reportage-preview-${index}`);
      if (el) {
        el.scrollIntoView({ block: 'start' });
      }
    });
  };

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
              Reportage
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
        <div className={`grid gap-2 rounded-3xl overflow-hidden border border-white/10 bg-black shadow-xl ${item.medias.length > 1 ? 'grid-cols-2' : 'grid-cols-1'}`}>
          {medias.map((media, idx) => (
            <button
              key={`${item.id}-m-${idx}`}
              onClick={() => openPreview(idx)}
              className="w-full h-56 bg-black"
            >
              {media.type === 'video' ? (
                <CustomVideoPlayer
                  src={media.url}
                  title={item.title}
                  description={item.detail}
                  hashtags={['ChooseMe', 'Presse', 'Actu']}
                  className="w-full h-full"
                />
              ) : (
                <img
                  src={media.url}
                  alt={item.title}
                  className="w-full h-full object-cover"
                  loading="lazy"
                />
              )}
            </button>
          ))}
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
          {item.pressWebsite && (
            <a
              href={item.pressWebsite.startsWith('http') ? item.pressWebsite : `https://${item.pressWebsite}`}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-1 mt-2 text-[#19DB8A] text-xs hover:underline"
            >
              <LinkIcon size={12} />
              {item.pressWebsite}
            </a>
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

      {previewOpen && (
        <div className="fixed inset-0 z-[100] bg-[#050505]">
          <div className="absolute top-4 left-4 right-4 flex justify-between items-center z-20">
            <span className="text-white/70 text-xs bg-black/50 border border-white/10 rounded-full px-3 py-1">
              Média {previewStartIndex + 1}/{medias.length}
            </span>
            <button
              onClick={() => setPreviewOpen(false)}
              className="w-9 h-9 rounded-full border border-white/20 bg-black/40 text-white flex items-center justify-center"
            >
              <X size={16} />
            </button>
          </div>

          <div className="h-full overflow-y-auto snap-y snap-mandatory">
            {medias.map((media, idx) => (
              <section
                id={`reportage-preview-${idx}`}
                key={`preview-${item.id}-${idx}`}
                className="h-screen snap-start flex items-center justify-center bg-[#050505] px-4 py-16"
              >
                <div className="w-full h-full max-h-[86vh] rounded-3xl overflow-hidden bg-black border border-white/10">
                  {media.type === 'video' ? (
                    <CustomVideoPlayer
                      src={media.url}
                      title={item.title}
                      description={item.detail}
                      hashtags={['ChooseMe', 'Presse', 'Actu']}
                      className="w-full h-full"
                    />
                  ) : (
                    <img src={media.url} alt={item.title} className="w-full h-full object-contain bg-black" />
                  )}
                </div>
              </section>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default ReportageDetailPage;
