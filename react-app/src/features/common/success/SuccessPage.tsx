import React from 'react';

// Correspond à `ok_widget.dart` (écran de succès générique)

export const SuccessPage: React.FC = () => {
  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <h1>Succès</h1>
        <p>L'action a été réalisée avec succès.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Message de confirmation et éventuels liens de navigation à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

