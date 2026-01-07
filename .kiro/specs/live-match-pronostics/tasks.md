# Implementation Plan: Live Match & Pronostics

## Overview

Ce plan d'implémentation divise le module Live Match & Pronostics en tâches incrémentales. Chaque tâche construit sur les précédentes pour créer un système fonctionnel de pronostics sportifs avec récompenses.

## Tasks

- [x] 1. Créer les modèles de données Firestore
  - Créer les records Dart pour matches, pronostics, wallets, transactions, withdrawals
  - Suivre les patterns existants de UserRecord et PublicationRecord
  - _Requirements: 1.1, 2.1, 4.1, 4.2_

- [ ]* 1.1 Écrire les tests de propriété pour les modèles de données
  - **Property 8: Wallet Balance Operations**
  - **Validates: Requirements 4.1, 4.2, 4.3**

- [x] 2. Implémenter FootballApiService
  - Créer le service d'intégration avec l'API Football externe
  - Implémenter getTodayMatches(), getLiveScores(), getMatchDetails()
  - Gérer les erreurs API et le cache
  - _Requirements: 1.1, 1.2, 1.4_

- [ ]* 2.1 Écrire les tests unitaires pour FootballApiService
  - Tester la gestion des erreurs API
  - Tester le cache en cas d'indisponibilité
  - _Requirements: 1.4_

- [x] 3. Créer la page de liste des matchs
  - Implémenter MatchesListWidget avec design ChooseMe
  - Afficher les matchs du jour avec badge LIVE
  - Intégrer le rafraîchissement automatique
  - _Requirements: 1.1, 1.2, 1.3_

- [ ]* 3.1 Écrire les tests de propriété pour l'affichage des matchs
  - **Property 1: Match List Rendering**
  - **Property 2: Match Status Display**
  - **Validates: Requirements 1.1, 1.2, 1.3, 1.5, 3.6**

- [x] 4. Implémenter PronosticService
  - Créer le service de gestion des pronostics
  - Implémenter la validation des horaires et l'unicité
  - Gérer l'horodatage serveur
  - _Requirements: 2.1, 2.2, 2.3, 2.4_

- [ ]* 4.1 Écrire les tests de propriété pour PronosticService
  - **Property 3: Prediction Time Validation**
  - **Property 4: Prediction Uniqueness**
  - **Property 5: Server Timestamp Recording**
  - **Validates: Requirements 2.1, 2.2, 2.3, 2.4, 9.2**

- [x] 5. Créer la page de détail de match avec pronostics
  - Implémenter MatchDetailWidget avec formulaire de pronostic
  - Intégrer PronosticService pour la soumission
  - Afficher les messages de confirmation/erreur
  - _Requirements: 2.1, 2.5, 2.6_

- [ ]* 5.1 Écrire les tests unitaires pour le formulaire de pronostic
  - Tester les messages de confirmation et d'erreur
  - Tester la validation côté UI
  - _Requirements: 2.5, 2.6_

- [ ] 6. Checkpoint - Tester le module de base
  - S'assurer que tous les tests passent, demander à l'utilisateur si des questions se posent.

- [x] 7. Implémenter WalletService
  - Créer le service de gestion du portefeuille
  - Implémenter les opérations de crédit et les retraits
  - Gérer la validation des seuils
  - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.6_

- [ ]* 7.1 Écrire les tests de propriété pour WalletService
  - **Property 9: Withdrawal Threshold Validation**
  - **Property 10: Reward Type Recording**
  - **Validates: Requirements 4.4, 4.6, 5.2, 5.3**

- [x] 8. Créer la page Wallet
  - Implémenter WalletWidget avec solde et historique
  - Créer WithdrawalWidget pour les demandes de retrait
  - Afficher les différents types de récompenses
  - _Requirements: 4.1, 4.3, 5.1, 5.3_

- [ ]* 8.1 Écrire les tests unitaires pour l'interface Wallet
  - Tester l'affichage du solde et de l'historique
  - Tester le formulaire de retrait
  - _Requirements: 4.3, 5.3_

- [x] 9. Implémenter LeaderboardService
  - Créer le service de calcul des gagnants
  - Implémenter l'algorithme de sélection des top 10
  - Gérer la mise à jour des statuts
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 3.5_

- [ ]* 9.1 Écrire les tests de propriété pour LeaderboardService
  - **Property 6: Winner Determination**
  - **Property 7: Prediction Status Updates**
  - **Validates: Requirements 3.1, 3.2, 3.3, 3.4, 3.5**

- [x] 10. Créer la page Leaderboard
  - Implémenter LeaderboardWidget avec classement des gagnants
  - Créer PronosticsHistoryWidget pour l'historique utilisateur
  - Afficher les statuts des pronostics
  - _Requirements: 3.6_

- [ ]* 10.1 Écrire les tests unitaires pour le Leaderboard
  - Tester l'affichage du classement
  - Tester l'historique des pronostics
  - _Requirements: 3.6_

- [ ] 11. Checkpoint - Tester le système complet
  - S'assurer que tous les tests passent, demander à l'utilisateur si des questions se posent.

- [ ] 12. Ajouter les sections admin au dashboard
  - Étendre t_b_dgeneral_a_d_m_widget avec les sections Live Match
  - Créer les pages de gestion des matchs et retraits
  - Implémenter les statistiques admin
  - _Requirements: 7.1, 7.2, 7.3, 7.4, 7.5, 8.1, 8.2, 8.3, 8.4, 8.5_

- [ ]* 12.1 Écrire les tests d'intégration pour l'admin
  - Tester les fonctionnalités de gestion des matchs
  - Tester la validation des retraits
  - _Requirements: 7.1, 8.1_

- [ ] 13. Implémenter la sécurité et l'audit
  - Ajouter le rate limiting sur les pronostics
  - Implémenter l'audit logging
  - Ajouter la validation anti-fraude
  - _Requirements: 9.1, 9.3, 9.4, 9.5_

- [ ]* 13.1 Écrire les tests de propriété pour la sécurité
  - **Property 11: Rate Limiting**
  - **Property 12: Audit Logging**
  - **Validates: Requirements 9.3, 9.4**

- [ ] 14. Ajouter les notifications
  - Intégrer Firebase Cloud Messaging
  - Implémenter les notifications push et in-app
  - Créer les triggers pour les événements
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ]* 14.1 Écrire les tests d'intégration pour les notifications
  - Tester l'envoi des notifications
  - Tester les triggers d'événements
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ] 15. Implémenter les Cloud Functions
  - Créer syncMatches() pour la synchronisation API
  - Créer processMatchResults() pour le calcul des gagnants
  - Créer sendPredictionNotification() pour les notifications
  - _Requirements: 1.2, 3.1, 6.2_

- [ ]* 15.1 Écrire les tests unitaires pour les Cloud Functions
  - Tester la synchronisation des matchs
  - Tester le traitement des résultats
  - _Requirements: 1.2, 3.1_

- [ ] 16. Ajouter la conformité légale
  - Créer la page des conditions générales
  - Ajouter les mentions légales (18+, disclaimer)
  - Implémenter l'acceptation des CGU
  - _Requirements: 10.1, 10.2, 10.3, 10.4_

- [ ]* 16.1 Écrire les tests unitaires pour la conformité
  - Tester l'affichage des mentions légales
  - Tester l'acceptation des CGU
  - _Requirements: 10.1, 10.4_

- [x] 17. Intégration et navigation
  - Ajouter les routes vers les nouvelles pages
  - Intégrer le module dans la navigation principale
  - Ajouter l'icône Live Match dans le menu
  - _Requirements: 1.1_

- [ ]* 17.1 Écrire les tests d'intégration de navigation
  - Tester la navigation entre les pages
  - Tester l'accès depuis le menu principal
  - _Requirements: 1.1_

- [ ] 18. Tests finaux et optimisation
  - Exécuter tous les tests de propriété et unitaires
  - Optimiser les performances (cache, pagination)
  - Tester sur différents appareils
  - _Requirements: All_

- [ ] 19. Checkpoint final - Validation complète
  - S'assurer que tous les tests passent, demander à l'utilisateur si des questions se posent.

## Notes

- Les tâches marquées avec `*` sont optionnelles et peuvent être ignorées pour un MVP plus rapide
- Chaque tâche référence les requirements spécifiques pour la traçabilité
- Les checkpoints permettent une validation incrémentale
- Les tests de propriété valident les propriétés de correctness universelles
- Les tests unitaires valident les exemples spécifiques et cas limites
- L'implémentation suit l'architecture Flutter/Firebase existante
- Utiliser les couleurs ChooseMe (#208050, #19DB8A) et le design moderne