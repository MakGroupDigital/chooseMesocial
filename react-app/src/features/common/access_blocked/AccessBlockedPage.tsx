import React from 'react';

// Correspond à `accesbloked_widget.dart` (accès bloqué)

export const AccessBlockedPage: React.FC = () => {
  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <h1>Accès bloqué</h1>
        <p>Votre accès à cette section est temporairement bloqué.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Message d'explication, éventuels liens de contact ou support à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

