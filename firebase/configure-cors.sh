#!/bin/bash

# Script pour configurer CORS sur Firebase Storage
# Choose Me - Configuration CORS

echo "🔧 Configuration CORS Firebase Storage"
echo "======================================="
echo ""

# Vérifier si gcloud est installé
if ! command -v gcloud &> /dev/null; then
    echo "❌ Google Cloud SDK n'est pas installé"
    echo ""
    echo "📦 Installation de Google Cloud SDK..."
    echo ""
    echo "Option 1: Avec Homebrew (recommandé sur macOS)"
    echo "  brew install google-cloud-sdk"
    echo ""
    echo "Option 2: Installation manuelle"
    echo "  Télécharger depuis: https://cloud.google.com/sdk/docs/install"
    echo ""
    exit 1
fi

# Vérifier si gsutil est disponible
if ! command -v gsutil &> /dev/null; then
    echo "❌ gsutil n'est pas disponible"
    echo "Réinstallez Google Cloud SDK"
    exit 1
fi

echo "✅ Google Cloud SDK détecté"
echo ""

# Se connecter (si nécessaire)
echo "🔐 Vérification de l'authentification..."
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" &> /dev/null; then
    echo "Connexion à Google Cloud..."
    gcloud auth login
fi

echo "✅ Authentifié"
echo ""

# Définir le projet
echo "📁 Configuration du projet..."
gcloud config set project choose-me-l1izsi

echo "✅ Projet configuré: choose-me-l1izsi"
echo ""

# Appliquer la configuration CORS
echo "🌐 Application de la configuration CORS..."
gsutil cors set firebase/storage-cors.json gs://choose-me-l1izsi.appspot.com

if [ $? -eq 0 ]; then
    echo "✅ Configuration CORS appliquée avec succès !"
    echo ""
    
    # Vérifier la configuration
    echo "🔍 Vérification de la configuration..."
    gsutil cors get gs://choose-me-l1izsi.appspot.com
    
    echo ""
    echo "✅ Configuration CORS terminée !"
    echo ""
    echo "📝 Vous pouvez maintenant:"
    echo "  1. Tester le téléchargement de vidéos"
    echo "  2. Les vidéos doivent se télécharger directement"
    echo "  3. Plus d'ouverture de Firebase dans un nouvel onglet"
else
    echo "❌ Erreur lors de l'application de la configuration CORS"
    echo ""
    echo "Vérifiez:"
    echo "  1. Que vous avez les permissions nécessaires"
    echo "  2. Que le projet existe: choose-me-l1izsi"
    echo "  3. Que le bucket existe: gs://choose-me-l1izsi.appspot.com"
    exit 1
fi
