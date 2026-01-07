# Requirements Document

## Introduction

Ce document définit les exigences pour le module Live Match & Pronostics de ChooseMe. Ce module permet aux utilisateurs de suivre des matchs en direct, de faire des pronostics sur les résultats, et de gagner des récompenses. Il s'agit d'un jeu promotionnel et non d'une plateforme de paris sportifs.

## Glossary

- **System**: L'application ChooseMe
- **Match_Service**: Service de récupération des données de matchs via API externe
- **Pronostic_Service**: Service de gestion des pronostics utilisateurs
- **Wallet_Service**: Service de gestion du portefeuille et des récompenses
- **Leaderboard_Service**: Service de classement des gagnants
- **Admin_Dashboard**: Interface d'administration pour la gestion du module
- **User**: Utilisateur authentifié de l'application
- **Match**: Événement sportif avec deux équipes
- **Pronostic**: Prédiction d'un utilisateur sur le résultat d'un match
- **Wallet**: Portefeuille virtuel de l'utilisateur contenant son solde et historique
- **Reward**: Récompense attribuée aux gagnants (argent, points, abonnements)

## Requirements

### Requirement 1: Affichage des Matchs en Direct

**User Story:** As a user, I want to see live matches with real-time scores, so that I can follow sports events and make informed predictions.

#### Acceptance Criteria

1. WHEN a user opens the Live Match page, THE System SHALL display a list of today's matches with team names, competition, and start time
2. WHEN a match is in progress, THE System SHALL display a "LIVE" badge and update the score every 30-60 seconds
3. WHEN a match status changes (goal, half-time, end), THE System SHALL update the timeline display
4. IF the external API is unavailable, THEN THE System SHALL display cached data with a warning message
5. WHEN displaying match details, THE System SHALL show both team logos, current score, and match minute

### Requirement 2: Soumission de Pronostics

**User Story:** As a user, I want to submit predictions on match outcomes, so that I can participate in the promotional game.

#### Acceptance Criteria

1. WHEN a user selects a match before kickoff, THE Pronostic_Service SHALL allow submission of a prediction (Team A wins, Draw, Team B wins)
2. WHEN a match has started, THE Pronostic_Service SHALL reject any new prediction submissions
3. THE Pronostic_Service SHALL allow only one prediction per user per match
4. WHEN a prediction is submitted, THE System SHALL record the server timestamp
5. WHEN a prediction is successfully saved, THE System SHALL display a confirmation message "Pronostic enregistré avec succès"
6. IF a user attempts to submit a duplicate prediction, THEN THE System SHALL display an error message

### Requirement 3: Calcul des Gagnants

**User Story:** As a system administrator, I want the system to automatically determine winners after matches, so that rewards can be distributed fairly.

#### Acceptance Criteria

1. WHEN a match ends, THE Leaderboard_Service SHALL compare all predictions against the actual result
2. WHEN determining winners, THE Leaderboard_Service SHALL rank correct predictions by submission timestamp (earliest first)
3. THE Leaderboard_Service SHALL select the top 10 earliest correct predictions as winners
4. WHEN winners are determined, THE System SHALL update each winner's status to "Gagnant"
5. WHEN a prediction is incorrect, THE System SHALL update the status to "Perdant"
6. WHILE a match is in progress, THE System SHALL display prediction status as "En attente"

### Requirement 4: Gestion du Wallet

**User Story:** As a user, I want to manage my rewards wallet, so that I can track my earnings and request withdrawals.

#### Acceptance Criteria

1. THE Wallet_Service SHALL maintain a balance for each user
2. WHEN a user wins a reward, THE Wallet_Service SHALL credit the amount to their balance
3. THE Wallet_Service SHALL maintain a complete history of all gains and withdrawals
4. WHEN a user requests a withdrawal, THE Wallet_Service SHALL verify the minimum threshold (5$)
5. IF the balance is below the minimum threshold, THEN THE System SHALL reject the withdrawal request
6. WHEN a withdrawal is requested, THE System SHALL create a pending withdrawal record for admin validation

### Requirement 5: Types de Récompenses

**User Story:** As a platform administrator, I want to offer various reward types, so that users have flexible options for their winnings.

#### Acceptance Criteria

1. THE System SHALL support the following reward types: Mobile Money, ChooseMe Points, Premium Subscriptions, Sponsored Gifts
2. WHEN crediting a reward, THE Wallet_Service SHALL record the reward type and value
3. WHEN a user views their wallet, THE System SHALL display rewards grouped by type

### Requirement 6: Notifications

**User Story:** As a user, I want to receive notifications about my predictions and rewards, so that I stay informed about my participation.

#### Acceptance Criteria

1. WHEN a prediction is validated, THE System SHALL send a push notification
2. WHEN a match ends, THE System SHALL notify users who made predictions on that match
3. WHEN a user wins, THE System SHALL send a notification with the reward details
4. WHEN a reward is credited to the wallet, THE System SHALL send a confirmation notification
5. THE System SHALL display in-app notifications in the notification center

### Requirement 7: Administration des Matchs

**User Story:** As an administrator, I want to manage matches and rewards, so that I can control the promotional game.

#### Acceptance Criteria

1. WHEN an admin accesses the dashboard, THE Admin_Dashboard SHALL display match management options
2. THE Admin_Dashboard SHALL allow enabling/disabling specific matches for predictions
3. THE Admin_Dashboard SHALL allow defining reward amounts for each match
4. WHEN viewing match statistics, THE Admin_Dashboard SHALL display: number of predictions, active users, reward costs
5. THE Admin_Dashboard SHALL display a list of winners for each match

### Requirement 8: Validation des Retraits

**User Story:** As an administrator, I want to validate withdrawal requests, so that I can ensure proper fund distribution.

#### Acceptance Criteria

1. WHEN a withdrawal request is submitted, THE Admin_Dashboard SHALL display it in a pending list
2. THE Admin_Dashboard SHALL allow approving or rejecting withdrawal requests
3. WHEN a withdrawal is approved, THE Wallet_Service SHALL deduct the amount from user balance
4. WHEN a withdrawal is rejected, THE System SHALL notify the user with a reason
5. THE Admin_Dashboard SHALL display withdrawal history with status (pending, approved, rejected)

### Requirement 9: Sécurité et Anti-Fraude

**User Story:** As a platform operator, I want to prevent fraud, so that the promotional game remains fair.

#### Acceptance Criteria

1. THE System SHALL enforce one account per unique phone number
2. THE System SHALL use server-side timestamps for all prediction submissions
3. THE System SHALL implement rate limiting on prediction submissions
4. THE System SHALL log all user actions related to predictions and withdrawals
5. IF suspicious activity is detected, THEN THE System SHALL flag the account for review

### Requirement 10: Conformité Légale

**User Story:** As a platform operator, I want to ensure legal compliance, so that ChooseMe operates within regulations.

#### Acceptance Criteria

1. THE System SHALL display clear terms and conditions for the promotional game
2. THE System SHALL display an "18+" age restriction notice
3. THE System SHALL include a disclaimer: "ChooseMe n'est pas une plateforme de paris sportifs"
4. WHEN a user first accesses the Live Match feature, THE System SHALL require acceptance of terms
