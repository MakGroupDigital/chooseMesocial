import React, { useEffect, useState } from 'react';
import { WalletService, WalletStats } from '../services/walletService';

// Correspond à `wallet_widget.dart` (portefeuille utilisateur) avec logique réelle.

export const WalletPage: React.FC = () => {
  const [stats, setStats] = useState<WalletStats | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    void loadStats();
  }, []);

  async function loadStats() {
    try {
      setLoading(true);
      setError(null);
      const s = await WalletService.instance.getWalletStats();
      setStats(s);
    } catch (e: any) {
      setError(String(e));
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Portefeuille</h1>
        <p>Consultez le solde et l&apos;historique de vos gains.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <div
            style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'center',
              marginBottom: '0.75rem'
            }}
          >
            <div>
              <strong>Solde actuel</strong>
              <p style={{ margin: 0, fontSize: '0.85rem', opacity: 0.8 }}>
                Basé sur vos pronostics gagnants.
              </p>
            </div>
            <button className="icon-button" type="button" onClick={() => void loadStats()}>
              ⟳
            </button>
          </div>

          {loading && <p>Chargement du portefeuille...</p>}
          {error && <p style={{ color: '#ff6b6b' }}>{error}</p>}

          {stats && !loading && (
            <>
              <p style={{ fontSize: '1.6rem', margin: '0.25rem 0' }}>
                {stats.currentBalance.toFixed(2)} €
              </p>
              <p style={{ fontSize: '0.9rem', opacity: 0.8 }}>
                Points: <strong>{stats.currentPoints}</strong>
              </p>
              <p style={{ fontSize: '0.9rem', opacity: 0.8 }}>
                Retr. en attente:{' '}
                <strong>{stats.pendingWithdrawals.toFixed(2)} €</strong>
              </p>
              <p style={{ fontSize: '0.9rem', opacity: 0.8 }}>
                Gains ce mois:{' '}
                <strong>{stats.monthlyEarnings.toFixed(2)} €</strong>
              </p>
            </>
          )}
        </div>
      </div>
    </div>
  );
};

