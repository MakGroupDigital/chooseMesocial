import React from 'react';

// Correspond à `pubsucces_widget.dart` (succès publication)

export const PublicationSuccessPage: React.FC = () => {
  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <h1>Publication réussie</h1>
        <p>Votre post a été publié avec succès.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Boutons pour voir la publication, la partager, ou retourner au fil d'actualité à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

