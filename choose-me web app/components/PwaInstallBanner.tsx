import React, { useEffect, useMemo, useState } from 'react';
import { ArrowRight, Bell, CheckCircle2, Download, Ellipsis, Home, MoreVertical, Share2, Smartphone, X } from 'lucide-react';

type BeforeInstallPromptEvent = Event & {
  prompt: () => Promise<void>;
  userChoice: Promise<{ outcome: 'accepted' | 'dismissed'; platform: string }>;
};

const isStandaloneMode = () => {
  if (typeof window === 'undefined') return false;
  const navigatorWithStandalone = navigator as Navigator & { standalone?: boolean };
  return window.matchMedia('(display-mode: standalone)').matches || navigatorWithStandalone.standalone === true;
};

interface PwaInstallBannerProps {
  hasBottomNav?: boolean;
}

const DISMISSED_SESSION_KEY = 'choose-me-pwa-install-dismissed-session';

const PwaInstallBanner: React.FC<PwaInstallBannerProps> = ({ hasBottomNav = false }) => {
  const [installPrompt, setInstallPrompt] = useState<BeforeInstallPromptEvent | null>(null);
  const [isStandalone, setIsStandalone] = useState(false);
  const [isInstalling, setIsInstalling] = useState(false);
  const [showFallback, setShowFallback] = useState(false);
  const [isDismissedForSession, setIsDismissedForSession] = useState(() => {
    if (typeof window === 'undefined') return false;
    return sessionStorage.getItem(DISMISSED_SESSION_KEY) === 'true';
  });
  const [notificationPermission, setNotificationPermission] = useState<NotificationPermission>('default');

  const isIOS = useMemo(() => {
    if (typeof navigator === 'undefined') return false;
    return /iphone|ipad|ipod/i.test(navigator.userAgent);
  }, []);

  useEffect(() => {
    setIsStandalone(isStandaloneMode());

    if ('Notification' in window) {
      setNotificationPermission(Notification.permission);
    }

    if ('serviceWorker' in navigator) {
      navigator.serviceWorker.register('/sw.js').catch((error) => {
        console.warn('Choose-Me service worker registration failed:', error);
      });
    }

    const handleBeforeInstallPrompt = (event: Event) => {
      event.preventDefault();
      setInstallPrompt(event as BeforeInstallPromptEvent);
      setShowFallback(false);
    };

    const handleAppInstalled = () => {
      setIsStandalone(true);
      setInstallPrompt(null);
      setShowFallback(false);
      sessionStorage.removeItem(DISMISSED_SESSION_KEY);
    };

    window.addEventListener('beforeinstallprompt', handleBeforeInstallPrompt);
    window.addEventListener('appinstalled', handleAppInstalled);

    if (isIOS) {
      setShowFallback(true);
    }

    return () => {
      window.removeEventListener('beforeinstallprompt', handleBeforeInstallPrompt);
      window.removeEventListener('appinstalled', handleAppInstalled);
    };
  }, [isIOS]);

  const requestNotifications = async () => {
    if (!('Notification' in window) || Notification.permission !== 'default') return;

    try {
      const permission = await Notification.requestPermission();
      setNotificationPermission(permission);
    } catch (error) {
      console.warn('Choose-Me notification permission request failed:', error);
    }
  };

  const installApp = async () => {
    setIsInstalling(true);
    setShowFallback(false);

    if (isIOS) {
      setShowFallback(true);
      setIsInstalling(false);
      return;
    }

    if (!installPrompt) {
      await requestNotifications();
      setShowFallback(true);
      setIsInstalling(false);
      return;
    }

    try {
      await installPrompt.prompt();
      const choice = await installPrompt.userChoice;

      if (choice.outcome === 'accepted') {
        await requestNotifications();
        setInstallPrompt(null);
      } else {
        setShowFallback(true);
      }
    } catch (error) {
      console.warn('Choose-Me PWA install prompt failed:', error);
      setShowFallback(true);
    } finally {
      setIsInstalling(false);
    }
  };

  const dismissForSession = () => {
    sessionStorage.setItem(DISMISSED_SESSION_KEY, 'true');
    setIsDismissedForSession(true);
  };

  if (isStandalone || isDismissedForSession) return null;

  return (
    <div
      className={`fixed inset-x-3 z-[90] md:bottom-auto md:left-auto md:right-6 md:top-6 md:w-[430px] ${
        hasBottomNav ? 'bottom-[7.25rem]' : 'bottom-3'
      }`}
    >
      <div className="overflow-hidden rounded-3xl border border-white/15 bg-[#06150f]/95 text-white shadow-2xl shadow-black/40 backdrop-blur-2xl">
        <div className="relative p-4 sm:p-5">
          <button
            type="button"
            onClick={dismissForSession}
            aria-label="Masquer l’installation pour cette session"
            className="absolute right-3 top-3 inline-flex h-8 w-8 items-center justify-center rounded-full border border-white/10 bg-white/10 text-white/70 transition hover:bg-white/15 hover:text-white"
          >
            <X className="h-4 w-4" />
          </button>
          <div className="flex gap-4">
            <div className="flex h-12 w-12 shrink-0 items-center justify-center rounded-2xl bg-white text-[#208050] shadow-xl sm:h-14 sm:w-14">
              <Smartphone className="h-6 w-6 sm:h-7 sm:w-7" />
            </div>
            <div className="min-w-0">
              <p className="text-[11px] font-bold uppercase tracking-[0.28em] text-[#19DB8A]">Expérience native</p>
              <h2 className="mt-1 text-lg font-bold leading-tight sm:text-xl">Installez Choose-Me sur votre téléphone</h2>
              <p className="mt-2 text-xs leading-relaxed text-white/70 sm:text-sm">
                Profitez d’un accès direct, d’une navigation plus fluide et des notifications sportives en temps réel.
              </p>
            </div>
          </div>

          <div className="mt-4 grid gap-3 sm:mt-5 sm:grid-cols-[1fr_auto]">
            <button
              type="button"
              onClick={installApp}
              disabled={isInstalling}
              className="flex h-12 items-center justify-center gap-2 rounded-2xl bg-[#19DB8A] px-5 text-sm font-bold text-[#03140d] shadow-lg shadow-emerald-500/20 transition hover:bg-[#44efaa] disabled:cursor-wait disabled:opacity-80"
            >
              {isInstalling ? (
                <>
                  <Download className="h-4 w-4 animate-bounce" />
                  Ouverture...
                </>
              ) : (
                <>
                  <Download className="h-4 w-4" />
                  {isIOS ? "Installer sur iPhone" : "Installer l’app"}
                </>
              )}
            </button>

            <div className="flex items-center justify-center gap-2 rounded-2xl border border-white/10 bg-white/10 px-3 py-2 text-xs text-white/70">
              {notificationPermission === 'granted' ? (
                <CheckCircle2 className="h-4 w-4 text-[#19DB8A]" />
              ) : (
                <Bell className="h-4 w-4 text-[#FF8A3C]" />
              )}
              Notifications
            </div>
          </div>

          {showFallback && (
            <div className="mt-4 rounded-2xl border border-[#19DB8A]/25 bg-[#19DB8A]/[0.07] p-4 text-sm leading-relaxed text-white/82">
              <p className="font-semibold text-white">
                Cliquez sur le bouton avec 3 points, souvent en bas à droite ou en haut à droite selon votre version du navigateur. Cliquez sur Partager, puis Plus, choisissez Ajouter à l’écran d’accueil et confirmez.
              </p>

              <div className="custom-scrollbar mt-4 flex items-center gap-2 overflow-x-auto pb-1">
                <div className="min-w-[112px] rounded-2xl border border-white/10 bg-black/25 p-3 text-center">
                  <MoreVertical className="mx-auto h-5 w-5 text-[#19DB8A]" />
                  <p className="mt-1 text-[10px] font-bold uppercase tracking-wide text-white/70">3 points</p>
                  <p className="mt-0.5 text-[9px] font-semibold text-white/45">bas ou haut droit</p>
                </div>
                <ArrowRight className="h-4 w-4 shrink-0 text-[#19DB8A]" />
                <div className="min-w-[92px] rounded-2xl border border-white/10 bg-black/25 p-3 text-center">
                  <Share2 className="mx-auto h-5 w-5 text-[#19DB8A]" />
                  <p className="mt-1 text-[10px] font-bold uppercase tracking-wide text-white/70">Partager</p>
                </div>
                <ArrowRight className="h-4 w-4 shrink-0 text-[#19DB8A]" />
                <div className="min-w-[92px] rounded-2xl border border-white/10 bg-black/25 p-3 text-center">
                  <Ellipsis className="mx-auto h-5 w-5 text-[#19DB8A]" />
                  <p className="mt-1 text-[10px] font-bold uppercase tracking-wide text-white/70">Plus</p>
                </div>
                <ArrowRight className="h-4 w-4 shrink-0 text-[#19DB8A]" />
                <div className="min-w-[112px] rounded-2xl border border-white/10 bg-black/25 p-3 text-center">
                  <Home className="mx-auto h-5 w-5 text-[#19DB8A]" />
                  <p className="mt-1 text-[10px] font-bold uppercase tracking-wide text-white/70">Écran d’accueil</p>
                </div>
                <ArrowRight className="h-4 w-4 shrink-0 text-[#19DB8A]" />
                <div className="min-w-[92px] rounded-2xl border border-white/10 bg-black/25 p-3 text-center">
                  <CheckCircle2 className="mx-auto h-5 w-5 text-[#19DB8A]" />
                  <p className="mt-1 text-[10px] font-bold uppercase tracking-wide text-white/70">Confirmer</p>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default PwaInstallBanner;
