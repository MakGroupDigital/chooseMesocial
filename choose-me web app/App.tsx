
import React, { useState, useEffect, useRef } from 'react';
import { HashRouter as Router, Routes, Route, Navigate, useLocation, useNavigate } from 'react-router-dom';
import SplashPage from './features/onboarding/SplashPage';
import ModernOnboardingPage from './features/onboarding/ModernOnboardingPage';
import OnboardingChooseTypePage from './features/onboarding/OnboardingChooseTypePage';
import OnboardingCreateAccountPage from './features/onboarding/OnboardingCreateAccountPage';
import LoginPage from './features/auth/LoginPage';
import DashboardRouter from './features/home/DashboardRouter';
import AthleteDashboard from './features/home/dashboards/AthleteDashboard';
import RecruiterDashboard from './features/home/dashboards/RecruiterDashboard';
import PressDashboard from './features/home/dashboards/PressDashboard';
import LiveMatchesPage from './features/live_match/LiveMatchesPage';
import MatchDetailPage from './features/live_match/MatchDetailPage';
import MyPredictionsPage from './features/live_match/MyPredictionsPage';
import WalletPage from './features/wallet/WalletPage';
import MessagesPage from './features/messages/MessagesPage';
import NotificationsPage from './features/notifications/NotificationsPage';
import ProfileViewPage from './features/profile/ProfileViewPage';
import ProfileEditPage from './features/profile/ProfileEditPage';
import AthletePublicProfilePage from './features/profile/AthletePublicProfilePage';
import SettingsPage from './features/profile/SettingsPage';
import BecomeAthletePage from './features/profile/BecomeAthletePage';
import BecomePressPage from './features/profile/BecomePressPage';
import RecruiterVerificationPage from './features/profile/RecruiterVerificationPage';
import ExplorerPage from './features/explorer/ExplorerPage';
import ReportageDetailPage from './features/explorer/ReportageDetailPage';
import CreateContentPage from './features/content/CreateContentPage';
import CreatePressContentPage from './features/content/CreatePressContentPage';
import VideoDescriptionPage from './features/content/VideoDescriptionPage';
import PerformanceRecordingPage from './features/content/PerformanceRecordingPage';
import SharedVideoPage from './features/content/SharedVideoPage';
import BottomNav from './components/BottomNav';
import PermissionModal from './components/PermissionModal';
import { UserType, UserProfile, normalizeUserType } from './types';
import { getFirebaseAuth, getFirestoreDb } from './services/firebase';
import { onAuthStateChanged } from 'firebase/auth';
import { doc, getDoc, onSnapshot } from 'firebase/firestore';
import { usePermissions } from './hooks/usePermissions';
import { applyLanguage, applyTheme, loadAppSettings, SETTINGS_EVENT } from './services/appSettingsService';
import { ensureBrowserNotificationPermission, listenUserNotifications, notifyBrowser } from './services/notificationService';
import {
  clearGoogleRedirectPending,
  ensureUserProfile,
  getPendingGoogleRedirectUser,
  hasGoogleRedirectPending
} from './services/googleAuthService';
import { warmVideoFeedCache } from './services/feedService';
import { getCountryByCode } from './utils/phoneCountries';

const DeviceMockup: React.FC<{ children: React.ReactNode, showNav: boolean, userType?: UserType }> = ({ children, showNav, userType }) => {
  return (
    <div className="h-[100dvh] bg-[#050505] flex flex-col font-sans overflow-hidden">
      <div className={`flex-1 min-h-0 overflow-y-auto relative custom-scrollbar bg-[#050505] ${showNav ? 'pb-24' : ''}`}>
        {children}
      </div>
      {showNav && <BottomNav userType={userType || UserType.VISITOR} />}
    </div>
  );
};

const App: React.FC = () => {
  const [user, setUser] = useState<UserProfile | null>(null);
  const [selectedOnboardingType, setSelectedOnboardingType] = useState<UserType | undefined>(undefined);
  const [loading, setLoading] = useState(true);
  const seenNotificationIdsRef = useRef<Set<string>>(new Set());
  const profileUnsubscribeRef = useRef<null | (() => void)>(null);
  const location = useLocation();
  const navigate = useNavigate();
  const { isModalOpen, currentPermission, handleAllow, handleDeny } = usePermissions();

  const normalizeCountry = (rawCountry: unknown): string => {
    const value = String(rawCountry || '').trim();
    if (!value) return '';
    const upper = value.toUpperCase();
    if (/^[A-Z]{2}$/.test(upper)) {
      const resolved = getCountryByCode(upper);
      return resolved?.name || value;
    }
    return value;
  };

  useEffect(() => {
    // Précharge le feed pendant le splash pour affichage instantané à l'ouverture du Home.
    void warmVideoFeedCache().catch(() => {});
  }, []);

  useEffect(() => {
    let isMounted = true;

    const waitForAuthenticatedUser = async () => {
      const auth = getFirebaseAuth();
      if (auth.currentUser) return auth.currentUser;

      return await new Promise<any>((resolve) => {
        const timeout = window.setTimeout(() => {
          unsub();
          resolve(null);
        }, 2500);

        const unsub = onAuthStateChanged(auth, (user) => {
          if (user) {
            window.clearTimeout(timeout);
            unsub();
            resolve(user);
          }
        });
      });
    };

    const handleGoogleRedirect = async () => {
      try {
        const auth = getFirebaseAuth();
        const redirectPending = hasGoogleRedirectPending();
        const redirectUser = await getPendingGoogleRedirectUser(auth);
        const fallbackUser = redirectPending ? (auth.currentUser || (await waitForAuthenticatedUser())) : null;
        const resolvedUser = redirectUser || fallbackUser;

        if (!resolvedUser) {
          return;
        }

        const { isNewUser } = await ensureUserProfile(resolvedUser);
        clearGoogleRedirectPending();
        if (!isMounted) {
          return;
        }

        navigate(isNewUser ? '/onboarding/type' : '/home', { replace: true });
      } catch (error) {
        clearGoogleRedirectPending();
        console.error('❌ Erreur finalisation connexion Google:', error);
      }
    };

    void handleGoogleRedirect();

    return () => {
      isMounted = false;
    };
  }, [navigate]);

  useEffect(() => {
    const currentSettings = loadAppSettings();
    applyTheme(currentSettings.theme);
    applyLanguage(currentSettings.language);

    const handleSettingsChanged = (event: Event) => {
      const customEvent = event as CustomEvent;
      const next = customEvent.detail || loadAppSettings();
      applyTheme(next.theme);
      applyLanguage(next.language);
    };

    const handleStorage = (event: StorageEvent) => {
      if (event.key) {
        const next = loadAppSettings();
        applyTheme(next.theme);
        applyLanguage(next.language);
      }
    };

    window.addEventListener(SETTINGS_EVENT, handleSettingsChanged as EventListener);
    window.addEventListener('storage', handleStorage);

    const auth = getFirebaseAuth();
    const db = getFirestoreDb();

    const unsub = onAuthStateChanged(auth, (fbUser) => {
      if (profileUnsubscribeRef.current) {
        profileUnsubscribeRef.current();
        profileUnsubscribeRef.current = null;
      }

      if (!fbUser) {
        setUser(null);
        setLoading(false);
        return;
      }

      setLoading(true);

      try {
        // Utiliser onSnapshot pour écouter les changements en temps réel
        const usersDocRef = doc(db, 'users', fbUser.uid);
        const userDocRef = doc(db, 'user', fbUser.uid);

        const mapProfile = (data: any | undefined): UserProfile => ({
          uid: fbUser.uid,
          email: fbUser.email || data?.email || '',
          displayName: data?.displayName || data?.display_name || fbUser.displayName || fbUser.email || '',
          type: normalizeUserType(data?.type, UserType.VISITOR),
          onboardingCompleted:
            typeof data?.onboardingCompleted === 'boolean' ? data.onboardingCompleted : Boolean(data),
          recruiterSubcategory: data?.recruiterSubcategory || '',
          country: normalizeCountry(data?.country || data?.pays),
          city: data?.city || data?.ville || '',
          avatarUrl: data?.avatarUrl || data?.photoUrl || data?.photo_url || data?.avatar_url || fbUser.photoURL || undefined,
          sport: data?.sport || data?.sporttype || data?.sport_type || undefined,
          position: data?.position || data?.poste || undefined,
          height: data?.height || data?.taille || undefined,
          weight: data?.weight || data?.poids || undefined,
          stats: {
            matchesPlayed: data?.stats?.matchesPlayed || data?.matchesPlayed || data?.matches_played || 0,
            goals: data?.stats?.goals || data?.goals || data?.buts || 0,
            assists: data?.stats?.assists || data?.assists || data?.passes || 0
          }
        });

        profileUnsubscribeRef.current = onSnapshot(usersDocRef, async (snap) => {
          let data = snap.data() as any | undefined;
          if (!data) {
            const legacySnap = await getDoc(userDocRef);
            data = legacySnap.data() as any | undefined;
          }

          if (!data) {
            await ensureUserProfile(fbUser);
            const hydratedSnap = await getDoc(usersDocRef);
            data = hydratedSnap.data() as any | undefined;
          }
          
          console.log('🔍 Données Firebase brutes:', data);

          const profile: UserProfile = mapProfile(data);
          
          console.log('✅ Profil mappé:', profile);
          console.log('📸 Avatar URL:', profile.avatarUrl);
          console.log('🏃 Sport:', profile.sport);
          console.log('📍 Position:', profile.position);
          console.log('🌍 Pays:', profile.country);
          
          setUser(profile);
          setLoading(false);

          // Précharge aussi un cache feed "utilisateur" dès que le profil est connu.
          void warmVideoFeedCache({ userId: fbUser.uid }).catch(() => {});
        }, (error) => {
          console.error('❌ Erreur écoute profil utilisateur:', error);
          setUser(null);
          setLoading(false);
        });
      } catch (e) {
        console.error('❌ Erreur chargement profil utilisateur:', e);
        setUser(null);
        setLoading(false);
      }
    });

    return () => {
      window.removeEventListener(SETTINGS_EVENT, handleSettingsChanged as EventListener);
      window.removeEventListener('storage', handleStorage);
      if (profileUnsubscribeRef.current) {
        profileUnsubscribeRef.current();
        profileUnsubscribeRef.current = null;
      }
      unsub();
    };
  }, []);

  useEffect(() => {
    if (!user?.uid) return;
    seenNotificationIdsRef.current = new Set();

    void ensureBrowserNotificationPermission();
    const unsub = listenUserNotifications(user.uid, (items) => {
      items.forEach((item) => {
        if (seenNotificationIdsRef.current.has(item.id)) return;
        seenNotificationIdsRef.current.add(item.id);
        if (!item.read) {
          notifyBrowser(item.title, item.body);
        }
      });
    });

    return () => unsub();
  }, [user?.uid]);

  const handleSelectType = (type: UserType) => {
    // utilisé temporairement pendant l'onboarding avant création du compte Firebase
    setSelectedOnboardingType(type);
  };

  const handleLogin = () => {
    // l'état utilisateur est maintenant géré par Firebase (onAuthStateChanged)
  };

  if (loading) return <SplashPage />;

  const isAuthenticated = Boolean(user);
  const needsTypeSelection = Boolean(user && user.onboardingCompleted === false);
  const needsRecruiterSubcategory = Boolean(user && user.type === UserType.RECRUITER && !String(user.recruiterSubcategory || '').trim());

  const getHomePathByType = (type?: UserType): string => {
    if (type === UserType.ATHLETE) return '/dashboard/athlete';
    if (type === UserType.RECRUITER) return '/dashboard/recruiter';
    if (type === UserType.PRESS) return '/dashboard/press';
    return '/home';
  };

  const requireAppAccess = (element: React.ReactElement) => {
    if (!isAuthenticated) return <Navigate to="/login" replace />;
    if (needsTypeSelection || needsRecruiterSubcategory) return <Navigate to="/onboarding/type" replace />;
    return element;
  };

  const requireRole = (allowed: UserType[], element: React.ReactElement) => {
    if (!isAuthenticated) return <Navigate to="/login" replace />;
    if (needsTypeSelection || needsRecruiterSubcategory) return <Navigate to="/onboarding/type" replace />;
    if (!user || !allowed.includes(user.type)) {
      return <Navigate to={getHomePathByType(user?.type)} replace />;
    }
    return element;
  };

  const hideNavOn = ['/onboarding', '/login', '/onboarding/type', '/onboarding/register', '/splash', '/video-description', '/record-performance', '/settings', '/settings/become-athlete', '/settings/become-press', '/settings/verify-recruiter'];
  const hideNavByPrefix: string[] = [];
  const showNav =
    isAuthenticated &&
    !needsTypeSelection &&
    !needsRecruiterSubcategory &&
    !hideNavOn.includes(location.pathname) &&
    !hideNavByPrefix.some((prefix) => location.pathname.startsWith(prefix)) &&
    location.pathname !== '/';

  return (
    <DeviceMockup showNav={showNav} userType={user?.type}>
      {currentPermission && (
        <PermissionModal
          isOpen={isModalOpen}
          title={currentPermission.title}
          description={currentPermission.description}
          icon={currentPermission.icon}
          onAllow={handleAllow}
          onDeny={handleDeny}
        />
      )}
      <Routes>
        <Route path="/" element={isAuthenticated ? <Navigate to={needsTypeSelection || needsRecruiterSubcategory ? '/onboarding/type' : '/home'} replace /> : <Navigate to="/onboarding" replace />} />
        <Route path="/onboarding" element={isAuthenticated ? <Navigate to={needsTypeSelection || needsRecruiterSubcategory ? '/onboarding/type' : '/home'} replace /> : <ModernOnboardingPage />} />
        <Route path="/onboarding/register" element={isAuthenticated ? <Navigate to={needsTypeSelection || needsRecruiterSubcategory ? '/onboarding/type' : '/home'} replace /> : <OnboardingCreateAccountPage selectedType={selectedOnboardingType} />} />
        <Route path="/onboarding/type" element={!isAuthenticated ? <Navigate to="/login" replace /> : !(needsTypeSelection || needsRecruiterSubcategory) ? <Navigate to="/home" replace /> : <OnboardingChooseTypePage onSelect={handleSelectType} />} />
        <Route path="/login" element={isAuthenticated ? <Navigate to={needsTypeSelection || needsRecruiterSubcategory ? '/onboarding/type' : '/home'} replace /> : <LoginPage onLogin={handleLogin} />} />
        
        <Route path="/home" element={requireAppAccess(<DashboardRouter userType={user?.type || UserType.VISITOR} />)} />
        <Route path="/dashboard/athlete" element={requireRole([UserType.ATHLETE], <AthleteDashboard />)} />
        <Route path="/dashboard/recruiter" element={requireRole([UserType.RECRUITER], <RecruiterDashboard />)} />
        <Route path="/dashboard/press" element={requireRole([UserType.PRESS], <PressDashboard />)} />
        <Route path="/explorer" element={requireAppAccess(<ExplorerPage userType={user?.type || UserType.VISITOR} />)} />
        <Route path="/explorer/reportage/:id" element={requireAppAccess(<ReportageDetailPage />)} />
        <Route path="/create-content" element={requireRole([UserType.ATHLETE], <CreateContentPage userType={user?.type || UserType.ATHLETE} />)} />
        <Route path="/create-press-content" element={requireRole([UserType.PRESS], <CreatePressContentPage userType={user?.type || UserType.PRESS} />)} />
        <Route path="/video-description" element={requireRole([UserType.ATHLETE], <VideoDescriptionPage />)} />
        <Route path="/record-performance" element={requireRole([UserType.ATHLETE], <PerformanceRecordingPage userType={user?.type || UserType.ATHLETE} />)} />
        <Route path="/live-match" element={requireAppAccess(<LiveMatchesPage />)} />
        <Route path="/live-match/:id" element={requireAppAccess(<MatchDetailPage />)} />
        <Route path="/my-predictions" element={requireAppAccess(<MyPredictionsPage />)} />
        <Route path="/messages" element={requireRole([UserType.ATHLETE, UserType.RECRUITER, UserType.PRESS], <MessagesPage />)} />
        <Route path="/messages/:conversationId" element={requireRole([UserType.ATHLETE, UserType.RECRUITER, UserType.PRESS], <MessagesPage />)} />
        <Route path="/notifications" element={requireAppAccess(<NotificationsPage />)} />
        <Route path="/wallet" element={requireAppAccess(<WalletPage />)} />
        <Route path="/profile" element={requireAppAccess(<ProfileViewPage user={user!} />)} />
        <Route path="/profile/edit" element={requireAppAccess(<ProfileEditPage user={user!} />)} />
        <Route path="/settings" element={requireAppAccess(<SettingsPage />)} />
        <Route path="/settings/become-athlete" element={requireAppAccess(<BecomeAthletePage />)} />
        <Route path="/settings/become-press" element={requireAppAccess(<BecomePressPage />)} />
        <Route path="/settings/verify-recruiter" element={requireRole([UserType.RECRUITER], <RecruiterVerificationPage />)} />
        <Route path="/athlete/:athleteId" element={<AthletePublicProfilePage viewerType={user?.type} />} />
        <Route path="/video/:videoId" element={<SharedVideoPage />} />
        
        <Route path="*" element={<Navigate to={isAuthenticated ? (needsTypeSelection || needsRecruiterSubcategory ? '/onboarding/type' : '/home') : '/onboarding'} replace />} />
      </Routes>
    </DeviceMockup>
  );
};

const Root: React.FC = () => (
  <Router>
    <App />
  </Router>
);

export default Root;
