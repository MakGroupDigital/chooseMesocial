import React from 'react';
import { useParams } from 'react-router-dom';

// Correspond à `article_widget.dart` (lecture d'article)

export const ArticleViewPage: React.FC = () => {
  const { id } = useParams();

  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Article</h1>
        <p>ID: {id}</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Contenu de l'article (titre, texte, médias) à charger depuis Firebase.</p>
        </div>
      </div>
    </div>
  );
};

