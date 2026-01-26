import React from 'react';
import { Route, Routes, Navigate } from 'react-router-dom';

import { HomeChoosePage } from './features/home/main/HomeChoosePage';
import { NotificationsPage } from './features/home/notifications/NotificationsPage';
import { LiveMatchesPage } from './features/live_match/matches_list/LiveMatchesPage';

// Auth
import { LoginPage } from './features/auth/login/LoginPage';
import { WelcomePage } from './features/auth/welcome/WelcomePage';
import { PasswordResetPage } from './features/auth/password_reset/PasswordResetPage';

// Onboarding
import { OnboardingStarterPage } from './features/onboarding/starter/OnboardingStarterPage';
import { OnboardingChooseTypePage } from './features/onboarding/choose_type/OnboardingChooseTypePage';
import { OnboardingAccountStatusPage } from './features/onboarding/account_status/OnboardingAccountStatusPage';
import { OnboardingCreateAccountPage } from './features/onboarding/create_account/OnboardingCreateAccountPage';
import { OnboardingPlayerInfoPage } from './features/onboarding/player_info/OnboardingPlayerInfoPage';
import { ModernOnboardingPage } from './features/onboarding/modern_onboarding/ModernOnboardingPage';

// Profil
import { ProfileViewPage } from './features/profile/view/ProfileViewPage';
import { ProfileEditPage } from './features/profile/edit/ProfileEditPage';
import { ProfileTalentPage } from './features/profile/talent/ProfileTalentPage';

// Settings
import { SettingsMainPage } from './features/settings/main/SettingsMainPage';
import { SettingsPolicyPage } from './features/settings/policy/SettingsPolicyPage';

// Search / Talents
import { SearchTalentPage } from './features/search/talent/SearchTalentPage';

// Payment
import { PayPage } from './features/payment/pay/PayPage';
import { TeamPayPage } from './features/payment/team_pay/TeamPayPage';

// Live match (détail, classement, wallet)
import { MatchDetailPage } from './features/live_match/match_detail/MatchDetailPage';
import { LeaderboardPage } from './features/live_match/leaderboard/LeaderboardPage';
import { WalletPage } from './features/live_match/wallet/WalletPage';
import { WithdrawalPage } from './features/live_match/wallet/WithdrawalPage';

// Chat
import { ChatPage } from './features/chat/conversation/ChatPage';
import { MessageThreadPage } from './features/chat/messages/MessageThreadPage';

// Common (états génériques)
import { AccessBlockedPage } from './features/common/access_blocked/AccessBlockedPage';
import { NoAccessPage } from './features/common/no_access/NoAccessPage';
import { FeatureUnavailablePage } from './features/common/feature_unavailable/FeatureUnavailablePage';
import { ErrorPage } from './features/common/error/ErrorPage';
import { SuccessPage } from './features/common/success/SuccessPage';

// Admin / Dashboards
import { AdminDashboardPage } from './features/admin/dashboard/AdminDashboardPage';
import { AdminUsersPage } from './features/admin/users/AdminUsersPage';
import { AdminClubsPage } from './features/admin/clubs/AdminClubsPage';
import { AdminAthletesPage } from './features/admin/athletes/AdminAthletesPage';
import { AdminPressUsersPage } from './features/admin/press/AdminPressUsersPage';
import { AdminManagersPage } from './features/admin/managers/AdminManagersPage';
import { AdminPublicationsPage } from './features/admin/publications/AdminPublicationsPage';
import { AdminModerationPage } from './features/admin/moderation/AdminModerationPage';
import { AdminConfigPage } from './features/admin/config/AdminConfigPage';

// Clubs / Presse / Recruteurs
import { ClubDashboardPage } from './features/clubs/dashboard/ClubDashboardPage';
import { PressDashboardPage } from './features/press/dashboard/PressDashboardPage';
import { RecruiterDashboardPage } from './features/recruiters/dashboard/RecruiterDashboardPage';

// Contenu (articles, publications, reportages)
import { ArticleCreatePage } from './features/content/article_create/ArticleCreatePage';
import { ArticleViewPage } from './features/content/article_view/ArticleViewPage';
import { ArticleSuccessPage } from './features/content/article_success/ArticleSuccessPage';
import { PublicationCreatePage } from './features/content/publication_create/PublicationCreatePage';
import { PublicationSuccessPage } from './features/content/publication_success/PublicationSuccessPage';
import { ReportageCreatePage } from './features/content/reportage_create/ReportageCreatePage';
import { ReportageHomePage } from './features/content/reportage_home/ReportageHomePage';
import { ReportageViewPage } from './features/content/reportage_view/ReportageViewPage';
import { ReportageSuccessPage } from './features/content/reportage_success/ReportageSuccessPage';

// Routeur React qui reflète la logique GoRouter / FlutterFlow
export const AppRouter: React.FC = () => {
  return (
    <Routes>
      {/* Home */}
      <Route path="/" element={<Navigate to="/home" replace />} />
      <Route path="/home" element={<HomeChoosePage />} />

      {/* Auth */}
      <Route path="/welcome" element={<WelcomePage />} />
      <Route path="/login" element={<LoginPage />} />
      <Route path="/password-reset" element={<PasswordResetPage />} />

      {/* Onboarding */}
      <Route path="/onboarding" element={<ModernOnboardingPage />} />
      <Route path="/onboarding/start" element={<OnboardingStarterPage />} />
      <Route path="/onboarding/type" element={<OnboardingChooseTypePage />} />
      <Route path="/onboarding/account-status" element={<OnboardingAccountStatusPage />} />
      <Route path="/onboarding/create-account" element={<OnboardingCreateAccountPage />} />
      <Route path="/onboarding/player-info" element={<OnboardingPlayerInfoPage />} />

      {/* Notifications */}
      <Route path="/notifications" element={<NotificationsPage />} />

      {/* Profil */}
      <Route path="/profile" element={<ProfileViewPage />} />
      <Route path="/profile/edit" element={<ProfileEditPage />} />
      <Route path="/profile/talent" element={<ProfileTalentPage />} />

      {/* Paramètres */}
      <Route path="/settings" element={<SettingsMainPage />} />
      <Route path="/settings/policy" element={<SettingsPolicyPage />} />

      {/* Recherche */}
      <Route path="/search/talent" element={<SearchTalentPage />} />

      {/* Paiement */}
      <Route path="/pay" element={<PayPage />} />
      <Route path="/pay/team" element={<TeamPayPage />} />

      {/* Live match */}
      <Route path="/live-match" element={<LiveMatchesPage />} />
      <Route path="/live-match/:matchId" element={<MatchDetailPage />} />
      <Route path="/live-match/leaderboard" element={<LeaderboardPage />} />
      <Route path="/wallet" element={<WalletPage />} />
      <Route path="/wallet/withdrawal" element={<WithdrawalPage />} />

      {/* Chat */}
      <Route path="/chat" element={<ChatPage />} />
      <Route path="/chat/:chatId" element={<MessageThreadPage />} />

      {/* États génériques */}
      <Route path="/access-blocked" element={<AccessBlockedPage />} />
      <Route path="/no-access" element={<NoAccessPage />} />
      <Route path="/feature-unavailable" element={<FeatureUnavailablePage />} />
      <Route path="/error" element={<ErrorPage />} />
      <Route path="/success" element={<SuccessPage />} />

      {/* Admin */}
      <Route path="/admin" element={<AdminDashboardPage />} />
      <Route path="/admin/users" element={<AdminUsersPage />} />
      <Route path="/admin/clubs" element={<AdminClubsPage />} />
      <Route path="/admin/athletes" element={<AdminAthletesPage />} />
      <Route path="/admin/press" element={<AdminPressUsersPage />} />
      <Route path="/admin/managers" element={<AdminManagersPage />} />
      <Route path="/admin/publications" element={<AdminPublicationsPage />} />
      <Route path="/admin/moderation" element={<AdminModerationPage />} />
      <Route path="/admin/config" element={<AdminConfigPage />} />

      {/* Clubs / Presse / Recruteurs */}
      <Route path="/club/dashboard" element={<ClubDashboardPage />} />
      <Route path="/press/dashboard" element={<PressDashboardPage />} />
      <Route path="/recruiter/dashboard" element={<RecruiterDashboardPage />} />

      {/* Contenu */}
      <Route path="/articles/new" element={<ArticleCreatePage />} />
      <Route path="/articles/:id" element={<ArticleViewPage />} />
      <Route path="/articles/success" element={<ArticleSuccessPage />} />

      <Route path="/publications/new" element={<PublicationCreatePage />} />
      <Route path="/publications/success" element={<PublicationSuccessPage />} />

      <Route path="/reportages/new" element={<ReportageCreatePage />} />
      <Route path="/reportages" element={<ReportageHomePage />} />
      <Route path="/reportages/:id" element={<ReportageViewPage />} />
      <Route path="/reportages/success" element={<ReportageSuccessPage />} />

      {/* Fallback */}
      <Route path="*" element={<div>Page introuvable</div>} />
    </Routes>
  );
};


