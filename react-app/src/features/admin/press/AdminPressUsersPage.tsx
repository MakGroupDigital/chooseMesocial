import React from 'react';

// Correspond à `utilisateur_t_b_dpresse_widget.dart` (utilisateurs presse)

export const AdminPressUsersPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Presse</h1>
        <p>Gestion des comptes presse sur la plateforme.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des médias, validation et gestion des droits à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

