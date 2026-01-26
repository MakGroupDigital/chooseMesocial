import React from 'react';

// Correspond à `fonction_no_dispo_widget.dart` (fonctionnalité non disponible)

export const FeatureUnavailablePage: React.FC = () => {
  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <h1>Fonctionnalité indisponible</h1>
        <p>Cette section n'est pas encore disponible.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Texte explicatif, ETA, et éventuels liens d'information à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

