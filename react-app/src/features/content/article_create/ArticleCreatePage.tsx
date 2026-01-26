import React from 'react';

// Correspond à `ajout_article_widget.dart` (création d'article)

export const ArticleCreatePage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Nouvel article</h1>
        <p>Créez un article pour partager des actualités sportives.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Formulaire de création d'article (titre, contenu, image) à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

