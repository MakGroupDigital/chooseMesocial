import React from 'react';

// Correspond à `passforwar_widget.dart` (réinitialisation de mot de passe)

export const PasswordResetPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Mot de passe oublié</h1>
        <p>Recevez un lien de réinitialisation par email.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Formulaire de réinitialisation (email + bouton d'envoi) à implémenter ici.</p>
        </div>
      </div>
    </div>
  );
};

