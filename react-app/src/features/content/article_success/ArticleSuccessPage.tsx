import React from 'react';

// Correspond à `aerticlesucces_widget.dart` (succès de création d'article)

export const ArticleSuccessPage: React.FC = () => {
  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <h1>Article publié</h1>
        <p>Votre article a été publié avec succès.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Boutons pour voir l'article, partager, ou revenir au tableau de bord à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

