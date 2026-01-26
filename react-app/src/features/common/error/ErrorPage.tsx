import React from 'react';

// Correspond à `erreur_widget.dart` (écran d'erreur générique)

export const ErrorPage: React.FC = () => {
  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <h1>Erreur</h1>
        <p>Une erreur est survenue.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Message d'erreur détaillé, bouton de retour / rechargement à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

