import React from 'react';

// Correspond à `utilisateur_a_d_mmanagere_widget.dart` (utilisateurs managers)

export const AdminManagersPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Managers</h1>
        <p>Gestion des comptes managers.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des managers, validation et gestion des droits à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

