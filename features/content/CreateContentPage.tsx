import React, { useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  X,
  FlipHorizontal,
  Sparkles,
  Check,
  Loader2,
  Upload,
  Volume2,
  VolumeX,
  Zap
} from 'lucide-react';
import { UserType } from '../../types';
import { uploadPerformanceVideo } from '../../services/performanceService';
import { getFirebaseAuth, getFirestoreDb } from '../../services/firebase';
import { doc, getDoc } from 'firebase/firestore';

const CreateContentPage: React.FC<{ userType: UserType }> = ({ userType }) => {
  const navigate = useNavigate();
  const videoRef = useRef<HTMLVideoElement | null>(null);
  const canvasRef = useRef<HTMLCanvasElement | null>(null);
  const [caption, setCaption] = useState('');
  const [uploading, setUploading] = useState(false);
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [mediaRecorder, setMediaRecorder] = useState<MediaRecorder | null>(null);
  const [recording, setRecording] = useState(false);
  const [recordedUrl, setRecordedUrl] = useState<string | null>(null);
  const [recordedBlob, setRecordedBlob] = useState<Blob | null>(null);
  const [cameraFacing, setCameraFacing] = useState<'user' | 'environment'>('user');
  const [showCaptionInput, setShowCaptionInput] = useState(false);
  const [recordingTime, setRecordingTime] = useState(0);
  const [audioEnabled, setAudioEnabled] = useState(true);
  const [brightness, setBrightness] = useState(100);
  const [showSettings, setShowSettings] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const isAthlete = userType === UserType.ATHLETE;

  // Timer pour l'enregistrement
  useEffect(() => {
    let interval: NodeJS.Timeout;
    if (recording) {
      interval = setInterval(() => {
        setRecordingTime((prev) => prev + 1);
      }, 1000);
    } else {
      setRecordingTime(0);
    }
    return () => clearInterval(interval);
  }, [recording]);

  // Démarrer la caméra automatiquement
  useEffect(() => {
    startCamera();
    return () => {
      if (stream) {
        stream.getTracks().forEach((t) => t.stop());
      }
      if (recordedUrl) {
        URL.revokeObjectURL(recordedUrl);
      }
    };
  }, []);

  const startCamera = async () => {
    try {
      if (stream) {
        stream.getTracks().forEach((t) => t.stop());
      }
      const newStream = await navigator.mediaDevices.getUserMedia({
        video: { 
          facingMode: cameraFacing,
          width: { ideal: 1080 },
          height: { ideal: 1920 }
        },
        audio: true
      });
      setStream(newStream);
      if (videoRef.current) {
        videoRef.current.srcObject = newStream;
        videoRef.current.play().catch(() => {});
      }
    } catch (e) {
      console.error('Erreur caméra:', e);
      alert("Impossible d'accéder à la caméra. Vérifiez les permissions.");
    }
  };

  const toggleRecording = () => {
    if (!stream) return;
    
    if (!mediaRecorder || mediaRecorder.state === 'inactive') {
      // Démarrer l'enregistrement
      const chunks: BlobPart[] = [];
      
      // Créer un canvas pour appliquer les filtres
      const canvas = canvasRef.current;
      if (canvas && videoRef.current) {
        const ctx = canvas.getContext('2d');
        if (ctx) {
          canvas.width = videoRef.current.videoWidth || 1080;
          canvas.height = videoRef.current.videoHeight || 1920;
        }
      }
      
      const recorder = new MediaRecorder(stream, { 
        mimeType: 'video/webm;codecs=vp9',
        videoBitsPerSecond: 2500000
      });
      
      recorder.ondataavailable = (e) => {
        if (e.data && e.data.size > 0) {
          chunks.push(e.data);
        }
      };
      
      recorder.onstop = () => {
        const blob = new Blob(chunks, { type: 'video/webm' });
        const url = URL.createObjectURL(blob);
        setRecordedBlob(blob);
        setRecordedUrl(url);
        setShowCaptionInput(true);
        
        // Arrêter la caméra
        if (stream) {
          stream.getTracks().forEach((t) => t.stop());
          setStream(null);
        }
      };
      
      recorder.start();
      setMediaRecorder(recorder);
      setRecording(true);
    } else if (mediaRecorder.state === 'recording') {
      // Arrêter l'enregistrement
      mediaRecorder.stop();
      setRecording(false);
      setMediaRecorder(null);
    }
  };

  const toggleAudio = () => {
    if (stream) {
      stream.getAudioTracks().forEach((track) => {
        track.enabled = !audioEnabled;
      });
      setAudioEnabled(!audioEnabled);
    }
  };

  const switchCamera = () => {
    setCameraFacing((prev) => (prev === 'user' ? 'environment' : 'user'));
    setTimeout(() => startCamera(), 100);
  };

  const retakeVideo = () => {
    if (recordedUrl) {
      URL.revokeObjectURL(recordedUrl);
    }
    setRecordedUrl(null);
    setRecordedBlob(null);
    setCaption('');
    setShowCaptionInput(false);
    startCamera();
  };

  const handleFileImport = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    
    if (!file.type.startsWith('video/')) {
      alert('Veuillez sélectionner un fichier vidéo');
      return;
    }

    // Arrêter la caméra si active
    if (stream) {
      stream.getTracks().forEach((t) => t.stop());
      setStream(null);
    }

    // Créer le blob et l'URL
    const url = URL.createObjectURL(file);
    setRecordedBlob(file);
    setRecordedUrl(url);
    setShowCaptionInput(true);
  };

  const handlePublish = async () => {
    if (!recordedBlob || !caption.trim()) {
      alert('Veuillez ajouter une description');
      return;
    }

    setUploading(true);
    try {
      const auth = getFirebaseAuth();
      const db = getFirestoreDb();
      const currentUser = auth.currentUser;

      if (!currentUser) {
        alert('Vous devez être connecté');
        setUploading(false);
        return;
      }

      const userSnap = await getDoc(doc(db, 'users', currentUser.uid));
      const userData = userSnap.data() as any;

      console.log('📤 Publication de la vidéo...');
      
      await uploadPerformanceVideo(
        currentUser.uid,
        userData?.displayName || currentUser.email || 'Utilisateur',
        userData?.photoUrl,
        recordedBlob,
        caption,
        ''
      );

      console.log('✅ Vidéo publiée avec succès');
      
      // Rediriger vers le profil immédiatement
      navigate('/profile');
      
      // Afficher un message de succès
      setTimeout(() => {
        alert('Vidéo publiée ! Le transcodage en MP4 prendra ~60 secondes.');
      }, 500);
      
    } catch (e) {
      console.error('❌ Erreur publication:', e);
      alert('Erreur lors de la publication. Veuillez réessayer.');
      setUploading(false);
    }
  };

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs.toString().padStart(2, '0')}`;
  };

  return (
    <div className="fixed inset-0 bg-black z-50 flex flex-col">
      {/* Vidéo Stream - Optimisé pour mobile */}
      <div className="flex-1 relative overflow-hidden bg-black">
        {recordedUrl ? (
          <video
            src={recordedUrl}
            className="w-full h-full object-contain"
            autoPlay
            loop
            muted
            playsInline
          />
        ) : (
          <video
            ref={videoRef}
            className="w-full h-full object-cover"
            autoPlay
            muted
            playsInline
            style={{
              filter: `brightness(${brightness}%)`
            }}
          />
        )}
        
        {/* Canvas caché pour les filtres */}
        <canvas ref={canvasRef} className="hidden" />

        {/* Gradient overlay */}
        <div className="absolute inset-0 bg-gradient-to-b from-black/30 via-transparent to-black/50 pointer-events-none" />

        {/* Header avec contrôles */}
        <div className="absolute top-0 left-0 right-0 p-4 flex items-center justify-between z-10 safe-area-top">
          <button
            onClick={() => navigate(-1)}
            className="w-10 h-10 rounded-full bg-black/50 backdrop-blur-md flex items-center justify-center text-white hover:bg-black/70 transition-all"
          >
            <X size={24} />
          </button>

          {!recordedUrl && (
            <div className="flex gap-2">
              <button
                onClick={() => setShowSettings(!showSettings)}
                className="w-10 h-10 rounded-full bg-black/50 backdrop-blur-md flex items-center justify-center text-white hover:bg-black/70 transition-all"
              >
                <Zap size={20} />
              </button>
              <button
                onClick={switchCamera}
                className="w-10 h-10 rounded-full bg-black/50 backdrop-blur-md flex items-center justify-center text-white hover:bg-black/70 transition-all"
              >
                <FlipHorizontal size={20} />
              </button>
            </div>
          )}
        </div>

        {/* Panneau de réglages */}
        {showSettings && !recordedUrl && (
          <div className="absolute top-20 right-4 bg-black/80 backdrop-blur-md rounded-2xl p-4 z-20 w-64 border border-white/10">
            <div className="space-y-4">
              {/* Contrôle audio */}
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  {audioEnabled ? (
                    <Volume2 size={18} className="text-white" />
                  ) : (
                    <VolumeX size={18} className="text-white/50" />
                  )}
                  <span className="text-white text-sm font-semibold">Audio</span>
                </div>
                <button
                  onClick={toggleAudio}
                  className={`w-12 h-6 rounded-full transition-all ${
                    audioEnabled ? 'bg-[#19DB8A]' : 'bg-white/20'
                  }`}
                >
                  <div
                    className={`w-5 h-5 rounded-full bg-white transition-transform ${
                      audioEnabled ? 'translate-x-6' : 'translate-x-0.5'
                    }`}
                  />
                </button>
              </div>

              {/* Contrôle luminosité */}
              <div>
                <label className="text-white text-sm font-semibold mb-2 block">
                  Luminosité
                </label>
                <input
                  type="range"
                  min="50"
                  max="150"
                  value={brightness}
                  onChange={(e) => setBrightness(Number(e.target.value))}
                  className="w-full h-2 bg-white/20 rounded-lg appearance-none cursor-pointer accent-[#19DB8A]"
                />
                <div className="text-white/60 text-xs mt-1 text-center">
                  {brightness}%
                </div>
              </div>
            </div>
          </div>
        )}

        {/* Timer d'enregistrement */}
        {recording && (
          <div className="absolute top-20 left-1/2 -translate-x-1/2 z-10">
            <div className="bg-red-500/90 backdrop-blur-md px-4 py-2 rounded-full flex items-center gap-2 shadow-lg">
              <div className="w-3 h-3 bg-white rounded-full animate-pulse" />
              <span className="text-white font-bold text-sm">{formatTime(recordingTime)}</span>
            </div>
          </div>
        )}

        {/* Indicateur de caméra prête */}
        {!recording && !recordedUrl && stream && (
          <div className="absolute top-20 left-1/2 -translate-x-1/2 z-10">
            <div className="bg-black/60 backdrop-blur-md px-4 py-2 rounded-full">
              <span className="text-white text-sm font-semibold">
                Appuyez pour enregistrer
              </span>
            </div>
          </div>
        )}
      </div>

      {/* Contrôles d'enregistrement (mode caméra) */}
      {!recordedUrl && (
        <div className="bg-gradient-to-t from-black via-black/95 to-transparent p-6 safe-area-bottom">
          <div className="flex justify-center items-center gap-6">
            {/* Bouton Import */}
            <button
              onClick={() => fileInputRef.current?.click()}
              className="flex flex-col items-center gap-2 group"
            >
              <div className="w-14 h-14 rounded-full bg-white/10 backdrop-blur-md border-2 border-white/30 flex items-center justify-center group-hover:border-white/50 transition-all">
                <Upload size={24} className="text-white" />
              </div>
              <span className="text-white text-xs font-semibold">Importer</span>
            </button>

            {/* Bouton Enregistrer */}
            <button
              onClick={toggleRecording}
              className="relative group"
              disabled={!stream}
            >
              {recording ? (
                <div className="w-20 h-20 rounded-2xl bg-red-500 shadow-lg shadow-red-500/50 flex items-center justify-center animate-pulse">
                  <div className="w-8 h-8 bg-white rounded-sm" />
                </div>
              ) : (
                <div className="w-20 h-20 rounded-full border-4 border-white flex items-center justify-center group-hover:border-[#19DB8A] transition-all">
                  <div className="w-16 h-16 rounded-full bg-red-500 group-hover:bg-red-600 transition-all" />
                </div>
              )}
            </button>

            {/* Espace vide pour équilibrer */}
            <div className="w-14" />
          </div>
        </div>
      )}

      {/* Input file caché */}
      <input
        ref={fileInputRef}
        type="file"
        accept="video/*"
        className="hidden"
        onChange={handleFileImport}
      />

      {/* Panneau de légende (après enregistrement) */}
      {showCaptionInput && recordedUrl && (
        <div className="bg-gradient-to-t from-black via-black/95 to-transparent p-6 safe-area-bottom">
          <div className="space-y-4">
            <div>
              <label className="text-white text-sm font-semibold mb-2 block">
                Décrivez votre performance
              </label>
              <textarea
                value={caption}
                onChange={(e) => setCaption(e.target.value)}
                placeholder="Ajoutez une description..."
                className="w-full bg-white/10 backdrop-blur-md border border-white/20 rounded-2xl p-4 text-white placeholder-white/50 focus:border-[#19DB8A] focus:outline-none resize-none"
                rows={3}
                maxLength={150}
              />
              <div className="text-right text-white/50 text-xs mt-1">
                {caption.length}/150
              </div>
            </div>

            {isAthlete && (
              <div className="bg-[#19DB8A]/10 border border-[#19DB8A]/30 rounded-xl p-3 flex items-start gap-2">
                <Sparkles className="text-[#19DB8A] flex-shrink-0 mt-0.5" size={16} />
                <p className="text-white/80 text-xs leading-relaxed">
                  Les vidéos de qualité sont priorisées par notre IA pour les recruteurs
                </p>
              </div>
            )}

            <div className="flex gap-3">
              <button
                onClick={retakeVideo}
                className="flex-1 py-4 rounded-full bg-white/10 backdrop-blur-md border border-white/20 text-white font-bold hover:bg-white/20 transition-all"
              >
                Refaire
              </button>
              <button
                onClick={handlePublish}
                disabled={uploading || !caption.trim()}
                className="flex-1 py-4 rounded-full bg-[#19DB8A] text-black font-bold flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed hover:bg-[#19DB8A]/90 transition-all"
              >
                {uploading ? (
                  <>
                    <Loader2 size={20} className="animate-spin" />
                    Publication...
                  </>
                ) : (
                  <>
                    <Check size={20} />
                    Publier
                  </>
                )}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default CreateContentPage;
