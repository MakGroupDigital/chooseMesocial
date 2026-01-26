import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { signInWithEmailAndPassword } from 'firebase/auth';
import { firebaseAuth } from '@core/firebase/client';

// Correspond à `ConnexionWidget` (page de connexion Flutter) avec une UI sombre + vert ChooseMe.

export const LoginPage: React.FC = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await signInWithEmailAndPassword(firebaseAuth, email.trim(), password);
      navigate('/home');
    } catch (e: any) {
      setError(e?.message ?? 'Erreur de connexion');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div
      style={{
        minHeight: '100vh',
        position: 'relative',
        color: '#fff',
        backgroundColor: '#050505',
        overflow: 'hidden'
      }}
    >
      {/* Fond image + overlay vert foncé */}
      <div
        style={{
          position: 'absolute',
          inset: 0,
          backgroundImage:
            "url('/assets/images/Capture_decran_2025-03-07_a_20.39.00.png')",
          backgroundSize: 'cover',
          backgroundPosition: 'center',
          filter: 'brightness(0.4)'
        }}
      />
      <div
        style={{
          position: 'absolute',
          inset: 0,
          background:
            'linear-gradient(to bottom, rgba(0,0,0,0.4), rgba(32,128,80,0.8), rgba(5,5,5,0.95))'
        }}
      />

      {/* Cercles décoratifs verts */}
      <div
        style={{
          position: 'absolute',
          top: -80,
          right: -80,
          width: 260,
          height: 260,
          borderRadius: '50%',
          background:
            'radial-gradient(circle, rgba(25,219,138,0.4), transparent 60%)'
        }}
      />
      <div
        style={{
          position: 'absolute',
          bottom: -100,
          left: -100,
          width: 320,
          height: 320,
          borderRadius: '50%',
          background:
            'radial-gradient(circle, rgba(32,128,80,0.4), transparent 60%)'
        }}
      />

      {/* Contenu */}
      <div
        style={{
          position: 'relative',
          zIndex: 1,
          maxWidth: 420,
          margin: '0 auto',
          padding: '3.5rem 1.5rem 2.5rem'
        }}
      >
        {/* Header avec logo */}
        <div style={{ textAlign: 'center', marginBottom: '2.5rem' }}>
          <div
            style={{
              width: 110,
              height: 110,
              borderRadius: '50%',
              margin: '0 auto 1.25rem',
              backgroundColor: 'rgba(255,255,255,0.15)',
              border: '2px solid rgba(255,255,255,0.35)',
              boxShadow: '0 0 40px rgba(25,219,138,0.6)',
              overflow: 'hidden'
            }}
          >
            <img
              src="/assets/images/Sans_titre-2_(4).png"
              alt="ChooseMe"
              style={{ width: '100%', height: '100%', objectFit: 'cover' }}
            />
          </div>
          <h1 style={{ margin: 0, fontSize: '2.2rem', letterSpacing: 1 }}>
            ChooseMe
          </h1>
          <div
            style={{
              display: 'inline-block',
              marginTop: '0.6rem',
              padding: '0.25rem 1.2rem',
              borderRadius: 999,
              backgroundColor: 'rgba(255,255,255,0.15)',
              fontSize: '0.9rem',
              fontWeight: 500
            }}
          >
            Connexion
          </div>
        </div>

        {/* Carte de connexion */}
        <form
          onSubmit={handleSubmit}
          style={{
            backgroundColor: 'rgba(0,0,0,0.55)',
            borderRadius: 24,
            border: '1px solid rgba(255,255,255,0.22)',
            boxShadow: '0 18px 40px rgba(0,0,0,0.65)',
            padding: '1.8rem 1.6rem'
          }}
        >
          {/* Email */}
          <div style={{ marginBottom: '1.1rem' }}>
            <label style={{ fontSize: '0.9rem', opacity: 0.9 }}>
              Adresse e‑mail
            </label>
            <div
              style={{
                marginTop: '0.35rem',
                display: 'flex',
                alignItems: 'center',
                padding: '0.35rem 0.45rem',
                borderRadius: 16,
                backgroundColor: 'rgba(255,255,255,0.08)',
                border: '1px solid rgba(255,255,255,0.35)'
              }}
            >
              <div
                style={{
                  width: 34,
                  height: 34,
                  borderRadius: 12,
                  backgroundColor: 'rgba(255,255,255,0.18)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  marginRight: 8,
                  fontSize: '0.9rem'
                }}
              >
                @
              </div>
              <input
                type="email"
                required
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="exemple@email.com"
                style={{
                  flex: 1,
                  border: 'none',
                  outline: 'none',
                  background: 'transparent',
                  color: '#fff',
                  fontSize: '0.95rem'
                }}
              />
            </div>
          </div>

          {/* Mot de passe */}
          <div style={{ marginBottom: '0.6rem' }}>
            <label style={{ fontSize: '0.9rem', opacity: 0.9 }}>
              Mot de passe
            </label>
            <div
              style={{
                marginTop: '0.35rem',
                display: 'flex',
                alignItems: 'center',
                padding: '0.35rem 0.45rem',
                borderRadius: 16,
                backgroundColor: 'rgba(255,255,255,0.08)',
                border: '1px solid rgba(255,255,255,0.35)'
              }}
            >
              <div
                style={{
                  width: 34,
                  height: 34,
                  borderRadius: 12,
                  backgroundColor: 'rgba(255,255,255,0.18)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  marginRight: 8,
                  fontSize: '0.9rem'
                }}
              >
                *
              </div>
              <input
                type="password"
                required
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Entrez votre mot de passe"
                style={{
                  flex: 1,
                  border: 'none',
                  outline: 'none',
                  background: 'transparent',
                  color: '#fff',
                  fontSize: '0.95rem'
                }}
              />
            </div>
          </div>

          {/* Mot de passe oublié */}
          <div
            style={{
              textAlign: 'right',
              marginBottom: '1.2rem',
              fontSize: '0.85rem',
              cursor: 'pointer'
            }}
            onClick={() => navigate('/password-reset')}
          >
            Mot de passe oublié ?
          </div>

          {/* Erreur */}
          {error && (
            <div
              style={{
                marginBottom: '0.9rem',
                fontSize: '0.8rem',
                color: '#ff6b6b'
              }}
            >
              {error}
            </div>
          )}

          {/* Bouton connexion */}
          <button
            type="submit"
            disabled={loading}
            style={{
              width: '100%',
              height: 52,
              borderRadius: 16,
              border: 'none',
              backgroundColor: '#ffffff',
              color: PRIMARY_GREEN,
              fontWeight: 600,
              fontSize: '1rem',
              boxShadow: '0 12px 28px rgba(255,255,255,0.3)',
              cursor: loading ? 'default' : 'pointer'
            }}
          >
            {loading ? 'Connexion...' : 'Se connecter'}
          </button>
        </form>

        {/* Lien création compte */}
        <div
          style={{
            marginTop: '1.4rem',
            textAlign: 'center',
            fontSize: '0.9rem'
          }}
        >
          Pas encore de compte ?{' '}
          <button
            type="button"
            onClick={() => navigate('/onboarding/create-account')}
            style={{
              border: 'none',
              backgroundColor: '#fff',
              color: PRIMARY_GREEN,
              borderRadius: 999,
              padding: '0.25rem 0.9rem',
              fontWeight: 600,
              cursor: 'pointer',
              boxShadow: '0 8px 18px rgba(255,255,255,0.35)'
            }}
          >
            Créer un compte
          </button>
        </div>
      </div>
    </div>
  );
};

