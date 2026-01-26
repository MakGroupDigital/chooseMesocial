import React from 'react';

// Correspond à `creat_widget.dart` (création de compte)

export const OnboardingCreateAccountPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Créer un compte</h1>
        <p>Inscrivez-vous sur Choose-Me.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Formulaire d'inscription (nom, email, mot de passe, etc.) à implémenter ici.</p>
        </div>
      </div>
    </div>
  );
};

