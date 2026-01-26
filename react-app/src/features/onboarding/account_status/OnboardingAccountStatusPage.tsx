import React from 'react';

// Correspond à `statutcompte_widget.dart` (état / validation du compte)

export const OnboardingAccountStatusPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Statut du compte</h1>
        <p>Suivez la validation de votre compte.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Affichage du statut de validation, messages d'attente, etc. à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

