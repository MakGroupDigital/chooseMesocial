import React from 'react';

// Correspond à `a_d_mutilisateurs_widget.dart` (gestion des utilisateurs)

export const AdminUsersPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Utilisateurs</h1>
        <p>Gestion des comptes utilisateurs.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Tableau des utilisateurs, filtres et actions admin à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

