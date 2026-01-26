import React, { useState } from 'react';
import { WalletService } from '../services/walletService';

// Correspond à `withdrawal_widget.dart` (écran de demande de retrait) avec logique réelle.

export const WithdrawalPage: React.FC = () => {
  const [amount, setAmount] = useState('');
  const [method, setMethod] = useState<'mobile_money' | 'bank_transfer'>('mobile_money');
  const [phoneNumber, setPhoneNumber] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setSuccess(null);

    const parsedAmount = parseFloat(amount.replace(',', '.'));
    if (Number.isNaN(parsedAmount)) {
      setError('Montant invalide');
      setLoading(false);
      return;
    }

    const result = await WalletService.instance.requestWithdrawal({
      amount: parsedAmount,
      method,
      phoneNumber
    });

    if (result.error) {
      setError(result.error);
    } else {
      setSuccess('Votre demande de retrait a été envoyée avec succès.');
      setAmount('');
    }

    setLoading(false);
  }

  return (
    <div className="screen">
      <header className="screen-header">
        <h1>Retrait</h1>
        <p>Demandez un retrait depuis votre portefeuille.</p>
      </header>
      <div className="screen-content">
        <div className="card">
          <form onSubmit={handleSubmit}>
            <div style={{ marginBottom: '0.75rem' }}>
              <label style={{ fontSize: '0.9rem' }}>
                Montant
                <input
                  type="number"
                  min="0"
                  step="0.01"
                  value={amount}
                  onChange={(e) => setAmount(e.target.value)}
                  style={{
                    width: '100%',
                    marginTop: '0.25rem',
                    padding: '0.4rem 0.5rem',
                    borderRadius: 8,
                    border: '1px solid rgba(255,255,255,0.15)',
                    background: 'rgba(0,0,0,0.3)',
                    color: '#fff'
                  }}
                />
              </label>
            </div>

            <div style={{ marginBottom: '0.75rem' }}>
              <label style={{ fontSize: '0.9rem' }}>
                Méthode
                <select
                  value={method}
                  onChange={(e) =>
                    setMethod(e.target.value === 'bank_transfer' ? 'bank_transfer' : 'mobile_money')
                  }
                  style={{
                    width: '100%',
                    marginTop: '0.25rem',
                    padding: '0.4rem 0.5rem',
                    borderRadius: 8,
                    border: '1px solid rgba(255,255,255,0.15)',
                    background: 'rgba(0,0,0,0.3)',
                    color: '#fff'
                  }}
                >
                  <option value="mobile_money">Mobile Money</option>
                  <option value="bank_transfer">Virement bancaire</option>
                </select>
              </label>
            </div>

            <div style={{ marginBottom: '0.75rem' }}>
              <label style={{ fontSize: '0.9rem' }}>
                Numéro de téléphone
                <input
                  type="tel"
                  value={phoneNumber}
                  onChange={(e) => setPhoneNumber(e.target.value)}
                  style={{
                    width: '100%',
                    marginTop: '0.25rem',
                    padding: '0.4rem 0.5rem',
                    borderRadius: 8,
                    border: '1px solid rgba(255,255,255,0.15)',
                    background: 'rgba(0,0,0,0.3)',
                    color: '#fff'
                  }}
                />
              </label>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="icon-button"
              style={{ width: '100%', marginTop: '0.5rem' }}
            >
              {loading ? 'Envoi...' : 'Envoyer la demande de retrait'}
            </button>
          </form>

          {error && (
            <p style={{ marginTop: '0.5rem', color: '#ff6b6b', fontSize: '0.85rem' }}>{error}</p>
          )}
          {success && (
            <p style={{ marginTop: '0.5rem', color: '#19db8a', fontSize: '0.85rem' }}>
              {success}
            </p>
          )}
        </div>
      </div>
    </div>
  );
};

