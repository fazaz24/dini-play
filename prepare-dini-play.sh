#!/bin/bash

# Script d'exportation et de préparation du projet Dini Play
# Ce script prépare le projet pour le déploiement et crée une archive téléchargeable

echo "=== Script d'exportation et de préparation du projet Dini Play ==="
echo "Ce script va préparer votre projet pour le déploiement et créer une archive"

# Définir les variables
PROJECT_DIR="/home/ubuntu/dini-play"
EXPORT_DIR="/home/ubuntu/dini-play-export"
ARCHIVE_NAME="dini-play-deployment.tar.gz"

# Créer le répertoire d'exportation
echo "Création du répertoire d'exportation..."
mkdir -p $EXPORT_DIR

# Copier les fichiers du projet
echo "Copie des fichiers du projet..."
cp -r $PROJECT_DIR/* $EXPORT_DIR/

# Nettoyer les fichiers inutiles pour le déploiement
echo "Nettoyage des fichiers temporaires et des dépendances..."
cd $EXPORT_DIR
rm -rf node_modules
find . -name "node_modules" -type d -exec rm -rf {} +
find . -name ".next" -type d -exec rm -rf {} +
find . -name "dist" -type d -exec rm -rf {} +
find . -name ".turbo" -type d -exec rm -rf {} +
find . -name ".git" -type d -exec rm -rf {} +

# Créer un fichier .gitignore approprié
echo "Création d'un fichier .gitignore approprié..."
cat > .gitignore << EOL
# Dependencies
node_modules
.pnp
.pnp.js

# Testing
coverage

# Next.js
.next/
out/
build
dist

# Misc
.DS_Store
*.pem

# Debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Local env files
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Turbo
.turbo

# Vercel
.vercel
EOL

# Créer un fichier README.md détaillé
echo "Création d'un README.md détaillé..."
cat > README.md << EOL
# Dini Play - Planificateur de repas Halal avec IA

## À propos du projet

Dini Play est une application de planification de repas Halal enrichie par l'intelligence artificielle grâce à l'intégration de Google AI Studio (API Gemini). Cette application permet aux utilisateurs de découvrir, planifier et organiser des repas Halal avec des fonctionnalités avancées d'IA.

## Structure du projet

Ce projet utilise une architecture monorepo avec Turborepo :

- \`/apps/api\` : Backend NestJS avec Prisma et PostgreSQL
- \`/apps/web\` : Frontend Next.js avec Tailwind CSS
- \`/packages\` : Packages partagés (UI, configurations, etc.)

## Fonctionnalités principales

- Authentification et gestion des utilisateurs
- Catalogue de recettes Halal
- Planification de repas personnalisée
- Gestion du garde-manger
- Génération de listes de courses
- Fonctionnalités IA :
  - Analyse de recettes
  - Recommandations personnalisées
  - Planification intelligente de repas
  - Analyse nutritionnelle
  - Assistant conversationnel

## Prérequis

- Node.js 18+
- PostgreSQL
- Clé API Google AI Studio

## Installation

1. Clonez ce dépôt
2. Installez les dépendances :
   \`\`\`bash
   npm install
   \`\`\`
3. Configurez les variables d'environnement :
   - Copiez \`.env.example\` vers \`.env\` dans le dossier \`apps/api\`
   - Ajoutez votre clé API Google AI Studio et les informations de base de données

4. Initialisez la base de données :
   \`\`\`bash
   cd apps/api
   npx prisma migrate dev
   \`\`\`

5. Démarrez l'application en mode développement :
   \`\`\`bash
   npm run dev
   \`\`\`

## Déploiement

### Déploiement sur Vercel

1. Importez ce dépôt dans Vercel
2. Configurez les variables d'environnement dans l'interface Vercel
3. Déployez l'application

### Déploiement sur Hostinger

Consultez le guide de déploiement détaillé dans \`/docs/deployment-ia.md\`

## Documentation

- Documentation de l'API : \`/docs/api-ia-documentation.md\`
- Guide de déploiement : \`/docs/deployment-ia.md\`
- Résumé de l'intégration IA : \`/docs/resume-integration-ia.md\`

## Intégration Google AI Studio

Cette application utilise l'API Gemini de Google AI Studio pour enrichir l'expérience utilisateur avec des fonctionnalités d'IA. Pour utiliser ces fonctionnalités, vous devez obtenir une clé API sur [Google AI Studio](https://aistudio.google.com/).

## Licence

Ce projet est sous licence MIT.
EOL

# Créer un script d'installation pour faciliter le déploiement
echo "Création d'un script d'installation..."
cat > install.sh << EOL
#!/bin/bash

# Script d'installation pour Dini Play

echo "=== Installation de Dini Play ==="

# Installer les dépendances
echo "Installation des dépendances..."
npm install

# Configurer les variables d'environnement
echo "Configuration des variables d'environnement..."
if [ ! -f ./apps/api/.env ]; then
  echo "Création du fichier .env pour l'API..."
  cp ./apps/api/.env.example ./apps/api/.env
  echo "Veuillez éditer le fichier ./apps/api/.env pour configurer votre base de données et votre clé API Google AI Studio"
fi

# Initialiser la base de données
echo "Souhaitez-vous initialiser la base de données ? (y/n)"
read -r init_db
if [ "\$init_db" = "y" ]; then
  echo "Initialisation de la base de données..."
  cd apps/api
  npx prisma migrate dev
  cd ../..
fi

# Construire l'application
echo "Construction de l'application..."
npm run build

echo "=== Installation terminée ==="
echo "Pour démarrer l'application en mode développement : npm run dev"
echo "Pour démarrer l'application en mode production : npm run start"
EOL

chmod +x install.sh

# Créer un script de déploiement Vercel
echo "Création d'un script de déploiement Vercel..."
cat > deploy-vercel.sh << EOL
#!/bin/bash

# Script de déploiement Vercel pour Dini Play

echo "=== Déploiement de Dini Play sur Vercel ==="

# Vérifier si Vercel CLI est installé
if ! command -v vercel &> /dev/null; then
  echo "Installation de Vercel CLI..."
  npm install -g vercel
fi

# Se connecter à Vercel si nécessaire
echo "Connexion à Vercel..."
vercel login

# Déployer l'application
echo "Déploiement de l'application..."
vercel

echo "=== Déploiement terminé ==="
echo "Votre application est maintenant déployée sur Vercel !"
EOL

chmod +x deploy-vercel.sh

# Créer une archive du projet préparé
echo "Création de l'archive du projet..."
cd /home/ubuntu
tar -czvf $ARCHIVE_NAME -C $EXPORT_DIR .

echo "=== Préparation terminée ==="
echo "L'archive du projet a été créée : /home/ubuntu/$ARCHIVE_NAME"
echo "Vous pouvez télécharger cette archive et l'importer dans votre dépôt Git pour le déploiement"
echo "Utilisez les scripts install.sh et deploy-vercel.sh pour faciliter l'installation et le déploiement"
