import React from 'react';

// Correspond à `utilisateur_a_d_mclub_widget.dart` (gestion des clubs)

export const AdminClubsPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Clubs</h1>
        <p>Gestion des clubs sur la plateforme.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des clubs, validation et actions d'administration à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

