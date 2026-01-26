import React from 'react';

// Correspond à `reporsucces_widget.dart` (succès de création de reportage)

export const ReportageSuccessPage: React.FC = () => {
  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <h1>Reportage publié</h1>
        <p>Votre reportage a été publié avec succès.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Boutons pour voir le reportage, le partager, ou revenir au dashboard presse à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

