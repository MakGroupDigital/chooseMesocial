import React from 'react';

// Correspond à `parametre_widget.dart` (écran principal des paramètres)

export const SettingsMainPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Paramètres</h1>
        <p>Gérez les préférences de votre compte.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des sections (notifications, confidentialité, etc.) à implémenter ici.</p>
        </div>
      </div>
    </div>
  );
};

