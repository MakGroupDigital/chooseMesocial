import React from 'react';
import { useParams } from 'react-router-dom';

// Correspond à `reportage_widget.dart` (vue d'un reportage)

export const ReportageViewPage: React.FC = () => {
  const { id } = useParams();

  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Reportage</h1>
        <p>ID: {id}</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Contenu détaillé du reportage (texte, médias, stats) à charger depuis Firebase.</p>
        </div>
      </div>
    </div>
  );
};

