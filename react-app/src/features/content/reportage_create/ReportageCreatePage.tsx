import React from 'react';

// Correspond à `addreportage_widget.dart` (création de reportage)

export const ReportageCreatePage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Nouveau reportage</h1>
        <p>Créez un reportage pour couvrir un événement.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Formulaire de création de reportage (titre, description, médias) à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

