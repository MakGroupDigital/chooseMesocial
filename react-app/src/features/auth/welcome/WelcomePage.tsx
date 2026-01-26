import React from 'react';

// Correspond à `choose_me_widget.dart` (écran d'accueil / welcome)

export const WelcomePage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Bienvenue sur Choose-Me</h1>
        <p>Réseau social sportif connectant talents, recruteurs, clubs et presse.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>CTA et boutons d'orientation (connexion, création de compte, etc.) à implémenter ici.</p>
        </div>
      </div>
    </div>
  );
};

