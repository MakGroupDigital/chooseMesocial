import React from 'react';

// Correspond à `searche_talent_widget.dart` (recherche de talents)

export const SearchTalentPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Recherche de talents</h1>
        <p>Trouvez des sportifs selon vos critères.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Formulaire de filtres + liste de résultats à implémenter ici.</p>
        </div>
      </div>
    </div>
  );
};

