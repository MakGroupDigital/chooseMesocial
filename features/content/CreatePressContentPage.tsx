import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { ChevronLeft, Upload, Newspaper } from 'lucide-react';
import { createPressReportage, PRESS_ARTICLE_CATEGORIES, type PressArticleCategory } from '../../services/reportageService';
import { useAuth } from '../../services/firebase';
import { UserType } from '../../types';

const CreatePressContentPage: React.FC<{ userType: UserType }> = ({ userType }) => {
  const navigate = useNavigate();
  const { currentUser, loading } = useAuth();

  const [category, setCategory] = useState<PressArticleCategory>('Interview');
  const [title, setTitle] = useState('');
  const [detail, setDetail] = useState('');
  const [mediaFiles, setMediaFiles] = useState<File[]>([]);
  const [externalMediaUrls, setExternalMediaUrls] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const handleSubmit = async () => {
    if (!currentUser?.uid) {
      setError('Connexion requise.');
      return;
    }

    setError(null);
    setSuccess(null);
    setSubmitting(true);

    try {
      await createPressReportage({
        userId: currentUser.uid,
        category,
        title,
        detail,
        mediaFiles,
        externalMediaUrls: externalMediaUrls
          .split('\n')
          .map((url) => url.trim())
          .filter(Boolean)
      });

      setSuccess('Contenu presse publié avec succès.');
      setTimeout(() => navigate('/explorer'), 700);
    } catch (e: any) {
      setError(e?.message || 'Impossible de publier ce contenu.');
    } finally {
      setSubmitting(false);
    }
  };

  if (!loading && !currentUser) {
    return (
      <div className="min-h-full bg-[#050505] flex items-center justify-center p-6">
        <div className="w-full max-w-sm bg-[#0A0A0A] border border-white/10 rounded-2xl p-5 text-center">
          <p className="text-white font-semibold mb-2">Connexion requise</p>
          <p className="text-white/50 text-sm mb-4">Connectez-vous pour publier un contenu presse.</p>
          <button
            onClick={() => navigate('/login')}
            className="w-full py-3 rounded-xl bg-[#208050] text-white font-bold"
          >
            Se connecter
          </button>
        </div>
      </div>
    );
  }

  if (userType !== UserType.PRESS) {
    return (
      <div className="min-h-full bg-[#050505] flex items-center justify-center p-6">
        <div className="w-full max-w-sm bg-[#0A0A0A] border border-white/10 rounded-2xl p-5 text-center">
          <p className="text-white font-semibold mb-2">Accès réservé à la presse</p>
          <p className="text-white/50 text-sm mb-4">Activez d’abord votre compte presse dans les réglages.</p>
          <button
            onClick={() => navigate('/settings/become-press')}
            className="w-full py-3 rounded-xl bg-[#208050] text-white font-bold"
          >
            Obtenir un compte presse
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-full bg-[#050505] pb-28">
      <header className="p-6 pt-10 bg-gradient-to-b from-[#208050]/20 to-transparent">
        <div className="flex items-center gap-3">
          <button onClick={() => navigate(-1)} className="p-2 rounded-full bg-white/10 text-white">
            <ChevronLeft size={20} />
          </button>
          <h1 className="text-2xl font-bold text-white flex items-center gap-2">
            <Newspaper size={22} className="text-[#19DB8A]" />
            Ajouter un contenu presse
          </h1>
        </div>
      </header>

      <div className="px-6 space-y-3">
        <div className="bg-[#0A0A0A] border border-white/5 rounded-3xl p-4 space-y-3">
          <Field label="Catégorie">
            <select
              value={category}
              onChange={(e) => setCategory(e.target.value as PressArticleCategory)}
              className="w-full bg-transparent text-white text-sm outline-none"
            >
              {PRESS_ARTICLE_CATEGORIES.map((cat) => (
                <option key={cat} value={cat} className="bg-[#111111]">
                  {cat}
                </option>
              ))}
            </select>
          </Field>

          <Field label="Titre">
            <input
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="Ex: Interview exclusive du coach..."
              className="w-full bg-transparent text-white text-sm outline-none"
            />
          </Field>

          <Field label="Contenu / description">
            <textarea
              value={detail}
              onChange={(e) => setDetail(e.target.value)}
              rows={5}
              placeholder="Développez le contenu presse..."
              className="w-full bg-transparent text-white text-sm outline-none resize-none"
            />
          </Field>

          <Field label="Fichiers médias (photos/vidéos)">
            <label className="w-full py-2 px-3 rounded-xl border border-dashed border-white/20 text-white/70 text-sm flex items-center gap-2 cursor-pointer">
              <Upload size={15} className="text-[#19DB8A]" />
              <span className="truncate">
                {mediaFiles.length > 0 ? `${mediaFiles.length} fichier(s) sélectionné(s)` : 'Choisir plusieurs fichiers'}
              </span>
              <input
                type="file"
                accept="image/*,video/*"
                multiple
                className="hidden"
                onChange={(e) => setMediaFiles(Array.from(e.target.files || []))}
              />
            </label>
            {mediaFiles.length > 0 && (
              <div className="mt-2 text-xs text-white/50 space-y-1 max-h-24 overflow-y-auto custom-scrollbar">
                {mediaFiles.map((file) => (
                  <p key={file.name + file.size} className="truncate">
                    • {file.name}
                  </p>
                ))}
              </div>
            )}
          </Field>

          <Field label="URLs médias externes (une URL par ligne)">
            <textarea
              value={externalMediaUrls}
              onChange={(e) => setExternalMediaUrls(e.target.value)}
              placeholder={'https://.../media1\nhttps://.../media2'}
              rows={3}
              className="w-full bg-transparent text-white text-sm outline-none resize-none"
            />
          </Field>

          {error && <p className="text-red-400 text-xs">{error}</p>}
          {success && <p className="text-[#19DB8A] text-xs">{success}</p>}

          <button
            onClick={handleSubmit}
            disabled={submitting}
            className="w-full py-3 bg-[#19DB8A] text-black font-semibold rounded-2xl disabled:opacity-60"
          >
            {submitting ? 'Publication...' : 'Publier le contenu presse'}
          </button>
        </div>
      </div>
    </div>
  );
};

const Field: React.FC<{ label: string; children: React.ReactNode }> = ({ label, children }) => (
  <div className="py-3 px-3 bg-[#111111] rounded-2xl border border-white/5">
    <label className="text-xs text-white/50 mb-1 block">{label}</label>
    {children}
  </div>
);

export default CreatePressContentPage;
