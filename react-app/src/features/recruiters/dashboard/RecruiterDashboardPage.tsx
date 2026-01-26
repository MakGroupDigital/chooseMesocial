import React from 'react';

// Correspond à `tbdrecruteur_widget.dart` (dashboard recruteur)

export const RecruiterDashboardPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Dashboard Recruteur</h1>
        <p>Gérez vos recherches de talents et vos offres.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Sections pour les annonces, candidatures, favoris, etc. à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

