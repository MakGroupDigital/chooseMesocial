import React from 'react';

// Correspond à `completeinfosjouere_widget.dart` (compléter les infos joueur)

export const OnboardingPlayerInfoPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Informations joueur</h1>
        <p>Complétez vos informations sportives.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Formulaire d'informations sportives (poste, club, statistiques, etc.) à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

