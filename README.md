# TP Flutter - Application OptiLook 🕶️

## 📝 Présentation du projet
OptiLook est une application mobile e-commerce de lunettes développée avec Flutter. Ce projet intègre une architecture backend complète avec Firebase et une gestion de la persistance locale pour une expérience utilisateur fluide.

## ⚙️ Fonctionnalités implémentées

### 🔐 Authentification & Sécurité
- **Multi-connexion** : Support de l'authentification via **Email/Mot de passe**, **Google** et **X**.
- **Gestion de session** : Utilisation de **Shared Preferences** pour maintenir la connexion active et mémoriser l'identifiant utilisateur.

### 📦 Gestion du Catalogue (CRUD Firestore)
Le catalogue est entièrement synchronisé en temps réel avec **Cloud Firestore** :
- **Affichage dynamique** : Liste des produits récupérée en direct de la base de données.
- **Recherche intelligente** : Filtrage instantané des modèles via une barre de recherche.
- **Gestion Admin** : Possibilité d'**ajouter**, **modifier** et **supprimer** des produits directement depuis l'interface.

### 🎨 Design & Expérience Utilisateur
- Interface moderne avec dégradés (Marron Chocolat & Vert Olive).
- Feedback visuel lors du chargement des données.

## 👥 Équipe de développement (Groupe 3)
Ce projet a été réalisé  par les membres du groupe suivant :
- **Nkura Kikakala Winner**
- **Luthomo Ibele Blessing**
- **Wasso Kisembe Victorina**

## 🛠️ Technologies utilisées
- **Frontend** : Flutter & Dart
- **Backend** : Firebase Auth & Cloud Firestore
- **Local Storage** : Shared Preferences
