import React from 'react';

// Correspond à `moderation_widget.dart` (écran de modération générale)

export const AdminModerationPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Modération</h1>
        <p>Gérez les signalements et les contenus problématiques.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Liste des signalements et outils de modération à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

