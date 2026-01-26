import React from 'react';

// Écran React qui correspond à `NotificationWidget` (Flutter)
// On respecte la même responsabilité : gestion des préférences de notifications.

export const NotificationsPage: React.FC = () => {
  // TODO: connecter un vrai state (par ex. Zustand / Redux / Context)
  const [general, setGeneral] = React.useState(true);
  const [messages, setMessages] = React.useState(true);
  const [updates, setUpdates] = React.useState(true);
  const [reminders, setReminders] = React.useState(true);
  const [promotions, setPromotions] = React.useState(false);
  const [dnd, setDnd] = React.useState(false);
  const [sounds, setSounds] = React.useState(true);
  const [vibrations, setVibrations] = React.useState(true);

  return (
    <div className="screen screen-dark">
      <header className="screen-header">
        <button className="back-button" onClick={() => window.history.back()}>
          ←
        </button>
        <div>
          <h1>Notifications</h1>
          <p>Gérez vos alertes</p>
        </div>
        <div className="header-icon">🔔</div>
      </header>

      <div className="screen-content">
        <section className="card">
          <h2>Notifications générales</h2>
          <p>Activez ou désactivez toutes les notifications</p>
          <label className="switch-row">
            <div>
              <span>Activer les notifications</span>
              <small>Recevez toutes les alertes de l'application</small>
            </div>
            <input
              type="checkbox"
              checked={general}
              onChange={(e) => setGeneral(e.target.checked)}
            />
          </label>
        </section>

        <section className="card">
          <h2>Types de notifications</h2>
          <p>Choisissez les alertes que vous souhaitez recevoir</p>

          <label className="switch-row">
            <div>
              <span>Messages</span>
              <small>Nouveaux messages et conversations</small>
            </div>
            <input
              type="checkbox"
              checked={messages}
              onChange={(e) => setMessages(e.target.checked)}
            />
          </label>

          <label className="switch-row">
            <div>
              <span>Mises à jour</span>
              <small>Nouvelles fonctionnalités et améliorations</small>
            </div>
            <input
              type="checkbox"
              checked={updates}
              onChange={(e) => setUpdates(e.target.checked)}
            />
          </label>

          <label className="switch-row">
            <div>
              <span>Rappels</span>
              <small>Événements et rappels importants</small>
            </div>
            <input
              type="checkbox"
              checked={reminders}
              onChange={(e) => setReminders(e.target.checked)}
            />
          </label>

          <label className="switch-row">
            <div>
              <span>Promotions</span>
              <small>Offres spéciales et nouveautés</small>
            </div>
            <input
              type="checkbox"
              checked={promotions}
              onChange={(e) => setPromotions(e.target.checked)}
            />
          </label>
        </section>

        <section className="card">
          <h2>Horaires</h2>
          <p>Définissez quand recevoir les notifications</p>

          <label className="switch-row">
            <div>
              <span>Mode Ne pas déranger</span>
              <small>Désactiver les notifications la nuit</small>
            </div>
            <input
              type="checkbox"
              checked={dnd}
              onChange={(e) => setDnd(e.target.checked)}
            />
          </label>

          <div className="time-range">
            <div>
              <span>Plage horaire</span>
              <strong>22:00 - 07:00</strong>
            </div>
            <button className="icon-button" type="button">
              ✏️
            </button>
          </div>
        </section>

        <section className="card">
          <h2>Sons et vibrations</h2>
          <p>Personnalisez les alertes sonores</p>

          <label className="switch-row">
            <div>
              <span>Sons</span>
              <small>Activer les sons de notification</small>
            </div>
            <input
              type="checkbox"
              checked={sounds}
              onChange={(e) => setSounds(e.target.checked)}
            />
          </label>

          <label className="switch-row">
            <div>
              <span>Vibrations</span>
              <small>Activer les vibrations</small>
            </div>
            <input
              type="checkbox"
              checked={vibrations}
              onChange={(e) => setVibrations(e.target.checked)}
            />
          </label>
        </section>
      </div>
    </div>
  );
};

