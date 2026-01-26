import React from 'react';

// Correspond à `profil_u_t_widget.dart` (vue profil utilisateur)

export const ProfileViewPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Mon profil</h1>
        <p>Vue publique / détaillée du profil utilisateur.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Affichage des infos profil (photo, stats, bio...) à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

