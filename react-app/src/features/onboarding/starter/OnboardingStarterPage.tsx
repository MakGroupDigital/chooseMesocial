import React from 'react';

// Correspond à `choosestarter_widget.dart` (premier écran d'onboarding)

export const OnboardingStarterPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Commencer</h1>
        <p>Découvrez Choose-Me et commencez votre onboarding.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Contenu d'introduction / slider d'onboarding à implémenter ici.</p>
        </div>
      </div>
    </div>
  );
};

