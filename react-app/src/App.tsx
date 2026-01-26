import React from 'react';
import { Link } from 'react-router-dom';
import { AppRouter } from './router';

export const AppLayout: React.FC = () => {
  return (
    <div className="app-root">
      <header className="app-header">
        <div className="logo">Choose-Me</div>
        <nav className="main-nav">
          <Link to="/home">Accueil</Link>
          <Link to="/notifications">Notifications</Link>
          <Link to="/live-match">Live Match</Link>
        </nav>
      </header>
      <main className="app-main">
        <AppRouter />
      </main>
    </div>
  );
};

const App: React.FC = () => {
  return <AppLayout />;
};

export default App;

