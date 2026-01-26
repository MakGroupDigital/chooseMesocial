import React, { useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';

// Palette ChooseMe: vert ou orange unis (pas de gradient)
const PRIMARY_GREEN = '#208050';
const SECONDARY_GREEN = '#19DB8A';
const ACCENT_ORANGE = '#FF8A3C';

type OnboardingPage = {
  title: string;
  subtitle: string;
  description: string;
  image: string;
  iconLabel: string;
};

const PAGES: OnboardingPage[] = [
  {
    title: 'Découvre ton Talent',
    subtitle: 'Montre au monde ce que tu sais faire',
    description:
      'ChooseMe connecte les jeunes talents sportifs africains avec les recruteurs et clubs du monde entier.',
    image: '/assets/images/people-playing-basketball.jpg',
    iconLabel: 'TALENT'
  },
  {
    title: 'Connecte-toi',
    subtitle: 'Avec les meilleurs recruteurs',
    description:
      'Des centaines de clubs et recruteurs professionnels recherchent activement de nouveaux talents comme toi.',
    image: '/assets/images/childrens-playing-football.jpg',
    iconLabel: 'RECRUTEUR'
  },
  {
    title: 'Réalise tes Rêves',
    subtitle: 'Ta carrière commence ici',
    description:
      'Crée ton profil, partage tes performances et laisse les opportunités venir à toi.',
    image: '/assets/images/Capture_decran_2025-03-07_a_20.04.39.png',
    iconLabel: 'CARRIÈRE'
  }
];

export const ModernOnboardingPage: React.FC = () => {
  const [index, setIndex] = useState(0);
  const navigate = useNavigate();
  const page = PAGES[index];

  const backgroundStyle = useMemo(
    () => ({
      backgroundColor: '#050505'
    }),
    []
  );

  const goNext = () => {
    if (index < PAGES.length - 1) {
      setIndex((i) => i + 1);
    } else {
      navigate('/onboarding/create-account');
    }
  };

  return (
    <div className="screen" style={backgroundStyle}>
      {/* Header */}
      <header
        className="screen-header"
        style={{ paddingTop: '1.25rem', paddingInline: '1.5rem', paddingBottom: '1rem' }}
      >
        <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
          <div
            style={{
              width: 45,
              height: 45,
              borderRadius: '50%',
              backgroundColor: PRIMARY_GREEN,
              boxShadow: '0 8px 18px rgba(32,128,80,0.6)',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              overflow: 'hidden'
            }}
          >
            {/* Logo de l’app */}
            <img
              src="/assets/images/Sans_titre-4.png"
              alt="ChooseMe logo"
              style={{ width: '100%', height: '100%', objectFit: 'cover' }}
            />
          </div>
          <div>
            <div style={{ fontWeight: 700 }}>ChooseMe</div>
            <div style={{ fontSize: '0.8rem', opacity: 0.7 }}>Réseau social sportif</div>
          </div>
        </div>

        <button
          type="button"
          onClick={() => navigate('/onboarding/create-account')}
          style={{
            borderRadius: 999,
            border: '1px solid rgba(255,255,255,0.22)',
            background: 'rgba(0,0,0,0.4)',
            color: '#fff',
            fontSize: '0.8rem',
            padding: '0.35rem 0.8rem',
            cursor: 'pointer'
          }}
        >
          Passer
        </button>
      </header>

      {/* Contenu */}
      <div className="screen-content" style={{ gap: '1.5rem', paddingBottom: '1.75rem' }}>
        {/* Carte image */}
        <section
          style={{
            position: 'relative',
            width: '100%',
            height: '260px',
            borderRadius: '28px',
            overflow: 'hidden',
            boxShadow: `0 20px 40px ${PRIMARY_GREEN}55`,
            backgroundColor: '#101010'
          }}
        >
          <div
            style={{
              position: 'absolute',
              inset: 0,
              backgroundImage: `url(${page.image})`,
              backgroundSize: 'cover',
              backgroundPosition: 'center',
              filter: 'brightness(0.7)'
            }}
          />
          <div
            style={{
              position: 'absolute',
              inset: 0,
              background:
                'linear-gradient(to bottom, rgba(0,0,0,0.15), rgba(0,0,0,0.9))'
            }}
          />

          {/* Badge step */}
          <div
            style={{
              position: 'absolute',
              top: 16,
              left: 16,
              borderRadius: 999,
              background: '#fff',
              color: PRIMARY_GREEN,
              padding: '0.25rem 0.8rem',
              fontSize: '0.8rem',
              fontWeight: 600
            }}
          >
            {index + 1}/{PAGES.length}
          </div>

          {/* Icone flottante */}
          <div
            style={{
              position: 'absolute',
              right: 18,
              bottom: 18,
              borderRadius: 20,
              padding: '0.6rem 0.9rem',
              backgroundColor: '#101010',
              border: `1px solid ${ACCENT_ORANGE}88`,
              backdropFilter: 'blur(10px)',
              fontSize: '0.7rem',
              letterSpacing: 1,
              textTransform: 'uppercase',
              color: '#fff'
            }}
          >
            {page.iconLabel}
          </div>
        </section>

        {/* Texte */}
        <section style={{ textAlign: 'center' }}>
          <h1
            style={{
              margin: 0,
              fontSize: '1.9rem',
              lineHeight: 1.25,
              color: SECONDARY_GREEN
            }}
          >
            {page.title}
          </h1>
          <p
            style={{
              margin: '0.5rem 0 0.25rem',
              fontSize: '1.05rem',
              fontWeight: 500,
              opacity: 0.85
            }}
          >
            {page.subtitle}
          </p>
          <p
            style={{
              margin: '0.35rem 0 0',
              fontSize: '0.9rem',
              opacity: 0.8,
              lineHeight: 1.6
            }}
          >
            {page.description}
          </p>
        </section>

        {/* Indicateur + boutons */}
        <section>
          {/* Dots */}
          <div
            style={{
              display: 'flex',
              justifyContent: 'center',
              gap: '0.4rem',
              marginBottom: '1.2rem'
            }}
          >
            {PAGES.map((p, i) => (
              <div
                key={p.title}
                style={{
                  height: 8,
                  width: i === index ? 32 : 8,
                  borderRadius: 999,
                  backgroundColor:
                    i === index ? SECONDARY_GREEN : 'rgba(255,255,255,0.25)',
                  transition: 'all 0.25s ease-out'
                }}
              />
            ))}
          </div>

          <div style={{ display: 'flex', gap: '0.75rem' }}>
            <button
              type="button"
              onClick={() => navigate('/login')}
              style={{
                flex: 1,
                height: 48,
                borderRadius: 14,
                border: '1px solid rgba(255,255,255,0.3)',
                backgroundColor: '#101010',
                color: '#fff',
                fontWeight: 600,
                cursor: 'pointer'
              }}
            >
              Connexion
            </button>
            <button
              type="button"
              onClick={goNext}
              style={{
                flex: 1.6,
                height: 48,
                borderRadius: 14,
                border: 'none',
                backgroundColor: PRIMARY_GREEN,
                color: '#fff',
                fontWeight: 600,
                cursor: 'pointer',
                boxShadow: `0 10px 25px ${PRIMARY_GREEN}88`,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                gap: '0.4rem'
              }}
            >
              {index === PAGES.length - 1 ? 'Commencer' : 'Suivant'}
              <span style={{ fontSize: '0.9rem' }}>→</span>
            </button>
          </div>

          <p
            style={{
              marginTop: '0.9rem',
              fontSize: '0.75rem',
              textAlign: 'center',
              opacity: 0.7
            }}
          >
            En continuant, vous acceptez nos conditions d&apos;utilisation.
          </p>
        </section>
      </div>
    </div>
  );
};

