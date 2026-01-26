import React from 'react';

// Correspond à `t_b_dgeneral_a_d_m_widget.dart` (tableau de bord admin général)

export const AdminDashboardPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Dashboard Admin</h1>
        <p>Vue d'ensemble des statistiques et modérations.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Widgets de stats, graphiques et raccourcis admin à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

