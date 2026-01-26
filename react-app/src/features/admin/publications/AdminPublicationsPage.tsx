import React from 'react';

// Correspond à `pub_a_d_m_widget.dart` (gestion des publications côté admin)

export const AdminPublicationsPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Publications</h1>
        <p>Modération et gestion des contenus publiés.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des publications, actions de validation / suppression à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

