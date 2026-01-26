import React from 'react';

// Correspond à `ajout_pub_widget.dart` (création de publication)

export const PublicationCreatePage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Nouvelle publication</h1>
        <p>Partagez un post sur le fil d'actualité.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Formulaire de publication (texte, médias) à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

