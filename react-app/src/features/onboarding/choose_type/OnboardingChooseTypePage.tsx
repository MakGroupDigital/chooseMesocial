import React from 'react';

// Correspond à `choisirtype_widget.dart` (choix du type d'utilisateur : talent, club, recruteur, presse, etc.)

export const OnboardingChooseTypePage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Choisissez votre profil</h1>
        <p>Sélectionnez votre rôle sur la plateforme.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Boutons / cartes pour choisir entre Talent, Club, Recruteur, Presse, etc. à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

