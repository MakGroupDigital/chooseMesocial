import React from 'react';

// Correspond à `utilisateurathlete_a_d_m_widget.dart` (gestion des athlètes)

export const AdminAthletesPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Athlètes</h1>
        <p>Gestion des profils athlètes.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des athlètes, validation, modération à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

