import React from 'react';

// Correspond à `pay_widget.dart` (paiement principal)

export const PayPage: React.FC = () => {
  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Paiement</h1>
        <p>Effectuez vos paiements sur Choose-Me.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <p>Intégration du flux de paiement (carte, mobile money, etc.) à implémenter.</p>
        </div>
      </div>
    </div>
  );
};

