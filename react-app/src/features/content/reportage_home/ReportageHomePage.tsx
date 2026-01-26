import React from 'react';

// Correspond à `reportagehome_widget.dart` (liste / accueil des reportages)

export const ReportageHomePage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Reportages</h1>
        <p>Découvrez les derniers reportages sportifs.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des reportages avec filtres et tri à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

