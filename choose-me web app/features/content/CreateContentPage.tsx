
import React, { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Camera,
  Video,
  Image as ImageIcon,
  ChevronLeft,
  Send,
  Sparkles,
  Settings2,
  RefreshCw,
  Upload,
  Pause,
  Play,
  Save
} from 'lucide-react';
import { UserType } from '../../types';
import Button from '../../components/Button';

const CreateContentPage: React.FC<{ userType: UserType }> = ({ userType }) => {
  const navigate = useNavigate();
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const [caption, setCaption] = useState('');
  const [title, setTitle] = useState('');
  const [uploading, setUploading] = useState(false);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [mediaRecorder, setMediaRecorder] = useState<MediaRecorder | null>(null);
  const [recording, setRecording] = useState(false);
  const [recordedUrl, setRecordedUrl] = useState<string | null>(null);
  const [source, setSource] = useState<'camera' | 'upload' | null>(null);
  const [cameraFacing, setCameraFacing] = useState<'user' | 'environment'>('user');
  const [fileName, setFileName] = useState<string | null>(null);

  const isAthlete = userType === UserType.ATHLETE;
  const isPress = userType === UserType.PRESS;

  useEffect(() => {
    // Nettoyer le flux quand on quitte la page
    return () => {
      if (stream) {
        stream.getTracks().forEach((t) => t.stop());
      }
      if (recordedUrl) {
        URL.revokeObjectURL(recordedUrl);
      }
    };
  }, [stream, recordedUrl]);

  const startCamera = async () => {
    try {
      if (stream) {
        stream.getTracks().forEach((t) => t.stop());
      }
      const newStream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: cameraFacing },
        audio: true
      });
      setStream(newStream);
      setSource('camera');
      if (videoRef.current) {
        videoRef.current.srcObject = newStream;
        videoRef.current.play().catch(() => {});
      }
      if (recordedUrl) {
        URL.revokeObjectURL(recordedUrl);
        setRecordedUrl(null);
      }
      setFileName(null);
    } catch (e) {
      alert("Impossible d'accéder à la caméra. Vérifiez les permissions du navigateur.");
    }
  };

  const toggleRecording = () => {
    if (!stream) {
      startCamera();
      return;
    }
    if (!mediaRecorder || mediaRecorder.state === 'inactive') {
      const chunks: BlobPart[] = [];
      const recorder = new MediaRecorder(stream, { mimeType: 'video/webm' });
      recorder.ondataavailable = (e) => {
        if (e.data && e.data.size > 0) {
          chunks.push(e.data);
        }
      };
      recorder.onstop = () => {
        const blob = new Blob(chunks, { type: 'video/webm' });
        const url = URL.createObjectURL(blob);
        if (recordedUrl) {
          URL.revokeObjectURL(recordedUrl);
        }
        setRecordedUrl(url);
        setSource('camera');
      };
      recorder.start();
      setMediaRecorder(recorder);
      setRecording(true);
    } else if (mediaRecorder.state === 'recording') {
      mediaRecorder.stop();
      setRecording(false);
    }
  };

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    if (!file.type.startsWith('video/')) {
      alert('Merci de sélectionner un fichier vidéo.');
      return;
    }
    const url = URL.createObjectURL(file);
    if (recordedUrl) {
      URL.revokeObjectURL(recordedUrl);
    }
    setRecordedUrl(url);
    setSource('upload');
    setFileName(file.name);
    if (stream) {
      stream.getTracks().forEach((t) => t.stop());
      setStream(null);
    }
  };

  const switchCameraFacing = () => {
    setCameraFacing((prev) => (prev === 'user' ? 'environment' : 'user'));
    // Redémarre la caméra avec la nouvelle orientation
    void startCamera();
  };

  const handlePublish = () => {
    setUploading(true);
    setTimeout(() => {
      setUploading(false);
      navigate('/home');
    }, 2000);
  };

  const handleSaveDraft = () => {
    // Ici on pourrait sauvegarder dans Firestore / Storage en brouillon.
    alert('Votre performance est sauvegardée en brouillon (simulation).');
  };

  return (
    <div className="min-h-screen bg-[#050505] p-6 flex flex-col">
      <header className="flex items-center justify-between mb-4 pt-4">
        <button onClick={() => navigate(-1)} className="text-white/60">
          <ChevronLeft size={28} />
        </button>
        <div className="flex flex-col items-center">
          <span className="text-[11px] uppercase tracking-[0.24em] text-[#19DB8A] font-semibold">
            Camera ChooseMe
          </span>
          <h1 className="text-base font-readex font-bold">
            {isAthlete ? 'Capturer une performance' : 'Créer un reportage'}
          </h1>
        </div>
        <button className="text-white/60">
          <Settings2 size={22} />
        </button>
      </header>

      <div className="flex-1 space-y-5">
        {/* CAMERA / PREVIEW */}
        <div className="aspect-[9/16] bg-[#0A0A0A] border border-white/10 rounded-[32px] overflow-hidden relative shadow-2xl flex items-center justify-center">
          {recordedUrl ? (
            <video
              src={recordedUrl}
              className="w-full h-full object-cover"
              controls
              playsInline
            />
          ) : (
            <video
              ref={videoRef}
              className="w-full h-full object-cover"
              autoPlay
              muted
              playsInline
            />
          )}
          {/* Overlay dégradé haut/bas */}
          <div className="pointer-events-none absolute inset-0 bg-gradient-to-b from-black/60 via-transparent to-black/70" />

          {/* Contrôles caméra sur l’aperçu */}
          <div className="absolute top-3 left-3 flex items-center gap-2">
            <span className="px-2 py-1 rounded-full bg-black/60 text-[10px] text-white/70 border border-white/15 uppercase tracking-[0.18em]">
              {source === 'upload' ? 'Importé' : 'Live'}
            </span>
            {fileName && (
              <span className="px-2 py-1 rounded-full bg-black/40 text-[9px] text-white/60 border border-white/10 max-w-[120px] truncate">
                {fileName}
              </span>
            )}
          </div>

          <div className="absolute top-3 right-3 flex gap-2">
            <button
              type="button"
              onClick={switchCameraFacing}
              className="p-2 rounded-full bg-black/50 border border-white/15 text-white"
            >
              <RefreshCw size={16} />
            </button>
          </div>

          <div className="absolute bottom-4 left-0 right-0 flex flex-col items-center gap-3">
            <div className="flex items-center gap-4">
              <label className="flex flex-col items-center gap-1 cursor-pointer">
                <div className="w-11 h-11 rounded-full bg-black/60 border border-white/20 flex items-center justify-center text-white">
                  <Upload size={18} />
                </div>
                <span className="text-[9px] text-white/60 uppercase tracking-[0.16em]">
                  Importer
                </span>
                <input
                  type="file"
                  accept="video/*"
                  className="hidden"
                  onChange={handleFileChange}
                />
              </label>

              <button
                type="button"
                onClick={toggleRecording}
                className="relative flex items-center justify-center"
              >
                <div className="w-16 h-16 rounded-full bg-[#19DB8A] shadow-[0_0_40px_rgba(25,219,138,0.6)] flex items-center justify-center border-4 border-black">
                  {recording ? (
                    <Pause size={22} className="text-black" />
                  ) : (
                    <Video size={22} className="text-black" />
                  )}
                </div>
              </button>

              <button
                type="button"
                onClick={startCamera}
                className="flex flex-col items-center gap-1 text-white/70"
              >
                <div className="w-11 h-11 rounded-full bg-black/60 border border-white/20 flex items-center justify-center">
                  <Camera size={18} />
                </div>
                <span className="text-[9px] uppercase tracking-[0.16em]">
                  Réinitialiser
                </span>
              </button>
            </div>

            <p className="text-[9px] text-white/50">
              Conseillé : filmer en vertical 9:16, bonne lumière et cadrage stable.
            </p>
          </div>
        </div>

        <div className="space-y-4">
          {isPress && (
            <div className="space-y-2">
              <label className="text-xs font-bold text-white/30 uppercase tracking-widest ml-1">Titre de l'article</label>
              <input 
                type="text" 
                placeholder="Ex: Nouveau transfert historique..."
                className="w-full bg-[#0A0A0A] border border-white/5 rounded-2xl p-4 text-white focus:border-[#19DB8A] transition-all"
                value={title}
                onChange={(e) => setTitle(e.target.value)}
              />
            </div>
          )}

          <div className="space-y-2">
            <label className="text-xs font-bold text-white/30 uppercase tracking-widest ml-1">Légende / Contenu</label>
            <textarea 
              rows={4}
              placeholder={isAthlete ? "Décrivez votre performance..." : "Écrivez votre article ici..."}
              className="w-full bg-[#0A0A0A] border border-white/5 rounded-2xl p-4 text-white focus:border-[#19DB8A] transition-all resize-none"
              value={caption}
              onChange={(e) => setCaption(e.target.value)}
            />
          </div>
        </div>

        {isAthlete && (
           <div className="bg-[#19DB8A]/5 border border-[#19DB8A]/20 p-4 rounded-2xl flex gap-3 items-center">
              <Sparkles className="text-[#19DB8A]" size={20} />
              <p className="text-[10px] text-white/60 leading-tight">
                <span className="text-[#19DB8A] font-bold">Astuce:</span> Les vidéos de haute qualité (HD) et bien cadrées sont priorisées par notre IA de scoutisme pour les recruteurs.
              </p>
           </div>
        )}
      </div>

      <div className="mt-6 space-y-3">
        <div className="flex gap-3">
          <Button
            onClick={handlePublish}
            disabled={uploading || (!caption && !title) || !recordedUrl}
            className="flex-1 py-4 text-sm shadow-2xl shadow-[#19DB8A]/10"
          >
            {uploading ? 'Publication en cours...' : (
              <>
                <Send size={18} /> {isAthlete ? 'Publier la performance' : 'Publier le contenu'}
              </>
            )}
          </Button>
          <Button
            onClick={handleSaveDraft}
            disabled={uploading}
            className="px-4 py-4 text-xs bg-[#0A0A0A] border border-white/10 text-white/70"
          >
            <Save size={16} />
          </Button>
        </div>
      </div>
    </div>
  );
};

export default CreateContentPage;
