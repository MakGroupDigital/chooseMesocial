import React from 'react';
import { Link } from 'react-router-dom';

// Correspond à `H_O_M_EchooseWidget` côté Flutter :
// écran d’accueil qui oriente l’utilisateur vers les différentes sections.

export const HomeChoosePage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Choose-Me</h1>
        <p>Réseau social sportif</p>
      </header>

      <div className="screen-content grid">
        <Link className="tile" to="/live-match">
          <h2>Live Match</h2>
          <p>Pronostics, classement, portefeuille</p>
        </Link>

        <Link className="tile" to="/notifications">
          <h2>Notifications</h2>
          <p>Gérez vos alertes</p>
        </Link>

        <Link className="tile" to="/search/talent">
          <h2>Talents</h2>
          <p>Recherchez des sportifs</p>
        </Link>

        {/* TODO: ajouter toutes les autres entrées (admin, clubs, presse, profil, settings, etc.) */}
      </div>
    </div>
  );
};

