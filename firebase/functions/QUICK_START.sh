#!/bin/bash

# 🚀 Script d'installation rapide Cloud Functions
# Choose Me - Firebase Functions

echo "🔥 Installation Firebase Cloud Functions pour Choose Me"
echo "=================================================="
echo ""

# Vérifier si Firebase CLI est installé
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI n'est pas installé"
    echo "📦 Installation de Firebase CLI..."
    npm install -g firebase-tools
    echo "✅ Firebase CLI installé"
else
    echo "✅ Firebase CLI déjà installé"
fi

# Se connecter à Firebase
echo ""
echo "🔐 Connexion à Firebase..."
firebase login

# Aller dans le dossier functions
cd "$(dirname "$0")"
echo ""
echo "📂 Dossier actuel: $(pwd)"

# Installer les dépendances
echo ""
echo "📦 Installation des dépendances..."
npm install

# Créer le fichier .buildpacks pour FFmpeg
echo ""
echo "🎬 Configuration de FFmpeg..."
echo "https://github.com/jonathanong/heroku-buildpack-ffmpeg-latest.git" > .buildpacks
echo "✅ Buildpack FFmpeg configuré"

# Vérifier le projet Firebase
echo ""
echo "🔍 Vérification du projet Firebase..."
firebase projects:list

# Demander confirmation pour le déploiement
echo ""
read -p "🚀 Voulez-vous déployer les functions maintenant? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Déploiement des Cloud Functions..."
    firebase deploy --only functions -P choose-me-l1izsi
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Déploiement réussi!"
        echo ""
        echo "📊 Vérifier les functions déployées:"
        firebase functions:list -P choose-me-l1izsi
        echo ""
        echo "📝 Voir les logs:"
        echo "   firebase functions:log -P choose-me-l1izsi"
        echo ""
        echo "🎉 Installation terminée avec succès!"
    else
        echo ""
        echo "❌ Erreur lors du déploiement"
        echo "📝 Consultez les logs pour plus d'informations"
    fi
else
    echo ""
    echo "⏭️  Déploiement annulé"
    echo ""
    echo "Pour déployer plus tard, exécutez:"
    echo "   firebase deploy --only functions -P choose-me-l1izsi"
fi

echo ""
echo "📚 Documentation:"
echo "   - README.md"
echo "   - DEPLOYMENT_GUIDE.md"
echo ""
