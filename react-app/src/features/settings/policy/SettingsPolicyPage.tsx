import React from 'react';

// Correspond à `politique_widget.dart` (politique / CGU / confidentialité)

export const SettingsPolicyPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Politique & Confidentialité</h1>
        <p>Consultez les conditions d'utilisation et la politique de confidentialité.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Texte légal et politique à reprendre depuis l'app Flutter / sources existantes.</p>
        </div>
      </div>
    </div>
  );
};

