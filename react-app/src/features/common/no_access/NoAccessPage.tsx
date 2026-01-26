import React from 'react';

// Correspond à `noacces_widget.dart` (pas d'accès à cette fonctionnalité)

export const NoAccessPage: React.FC = () => {
  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <h1>Accès non autorisé</h1>
        <p>Vous n'avez pas les droits nécessaires pour cette fonctionnalité.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Message d'erreur et éventuels liens (mise à niveau, contact admin) à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

