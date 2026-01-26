import React from 'react';

// Correspond à `tbclub_widget.dart` (dashboard club)

export const ClubDashboardPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Dashboard Club</h1>
        <p>Gérez le profil et les activités de votre club.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Sections pour gérer les équipes, matchs et demandes à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

