# Projet BTS 2025 - Système de Drone avec Traitement d'Image et Réalité Virtuelle

## 📋 Description Générale

Ce projet implémente un système complet de drone avec traitement d'image en temps réel et visualisation en réalité virtuelle. Le système est composé de quatre modules principaux qui communiquent via UDP et partagent des données via des mécanismes de FileMapping.

## 🏗️ Architecture du Système

```
┌─────────────────┐    UDP     ┌─────────────────┐
│                 │ ─────────▶ │                 │
│     DRONE       │            │    SERVEUR      │
│   (Capture)     │ ◄───────── │  (Hub Central)  │
│                 │            │                 │
└─────────────────┘            │ ┌─────────────┐ │
                                │ │  CHAI3D VR  │ │
                                │ │ (Intégré)   │ │
                                │ │ Traitement  │ │
                                │ │ & Affichage │ │
                                │ └─────────────┘ │
                                └─────────────────┘
                                     ▲   │
                                     │   │ UDP
                                     │   ▼
                               ┌─────────────────┐
                               │                 │
                               │     CLIENT      │
                               │  (Interface &   │
                               │   Contrôle)     │
                               └─────────────────┘
```

### Flux de Communication Détaillé

#### 🔄 Drone → Serveur (avec Chai3D intégré) → Client
1. **Drone** capture vidéo et envoie images brutes via UDP
2. **Serveur** reçoit les images et commandes de traitement des clients
3. **Serveur** contrôle directement **Chai3D** via FileMapping interne
4. **Chai3D** applique traitements selon les instructions du serveur
5. **Chai3D** retourne images traitées au **Serveur** via FileMapping
6. **Serveur** distribue les images finales via UDP vers **Client(s)**

#### 📡 Communication UDP Bidirectionnelle (Serveur ↔ Clients)
- **Client → Serveur** : Commandes de traitement, enregistrement, statuts
- **Serveur → Client** : Images traitées, confirmations, états système
- **Ports utilisés** : 55001 (images), 55002 (commandes/statuts)

## 📁 Structure du Projet

### `/client/` - Interface Client Java
- **Fonction** : Interface graphique pour visualiser les flux vidéo et contrôler les traitements
- **Technologies** : Java, Swing, OpenCV
- **Communication** : 
  - **Communication UDP bidirectionnelle** avec le serveur :
    - Envoie commandes de traitement et enregistrement au serveur
    - Reçoit images traitées et statuts du serveur

### `/serveur/` - Serveur de Traitement et Coordination
- **Fonction** : Hub central qui coordonne tous les flux et intègre Chai3D comme moteur de traitement
- **Technologies** : Java, OpenCV, JNI (FileMapping), Multi-threading, **Chai3D intégré**
- **Communication** : 
  - Reçoit images du drone via UDP
  - **Communication UDP bidirectionnelle** avec les clients :
    - Reçoit commandes de traitement des clients
    - Envoie images traitées et statuts aux clients
  - **Contrôle Chai3D intégré** : Lance et pilote l'exécutable Chai3D via FileMapping

### `/drone/` - Module Drone
- **Fonction** : Capture vidéo, gestion des capteurs et télémétrie
- **Technologies** : Java, OpenCV, GPIO (Raspberry Pi), Capteurs VL53L0X
- **Communication** : Envoie images brutes et télémétrie via UDP au serveur

### Exécutable Chai3D (Intégré Serveur)
- **Fichier** : `00-drone-ju.exe`
- **Fonction** : Moteur de traitement avancé contrôlé par le serveur Java
- **Technologies** : C++, Chai3D, OpenGL, Algorithmes de vision avancés
- **Communication** : 
  - **Contrôlé par le Serveur** : Lancé automatiquement par le serveur Java
  - **FileMapping bidirectionnel** avec le serveur pour échange d'images
  - Exécute les traitements selon les instructions du serveur

## 🔧 Configuration Réseau

- **Réseau** : 172.29.x.x
- **Ports UDP** :
  - 55000 : Images drone → serveur
  - 55001 : Images serveur ↔ clients (bidirectionnel)
  - 55002 : Commandes et statuts serveur ↔ clients (bidirectionnel)
  - 55003 : Télémétrie drone → serveur

### Communication Bidirectionnelle Serveur ↔ Clients
- **Port 55001** : Transmission des images traitées (serveur → clients)
- **Port 55002** : 
  - **Client → Serveur** : Commandes de traitement, enregistrement, désenregistrement
  - **Serveur → Client** : Confirmations, statuts système, gestion des erreurs

## 🚀 Démarrage Rapide

### Prérequis
- Java 21+ (OpenJDK recommandé)
- OpenCV 4.10.0
- Windows 10/11 (pour Chai3D)
- Réseau configuré en 172.29.x.x

### Ordre de Démarrage
1. **Serveur** : `cd serveur && traitement.bat`
2. **Client(s)** : `cd client && client.bat`
3. **Drone** : `cd drone && ./drone.sh` (sur Raspberry Pi)

## 📊 Types de Traitement d'Image

Le système offre plusieurs niveaux de traitement, coordonnés entre le serveur Java et Chai3D :

- **0** : **Aucun traitement** - Image originale du drone transmise directement
- **1** : **Détection de contours** - Algorithmes Canny (OpenCV) + traitements Chai3D
- **2** : **Détection de formes géométriques** - Reconnaissance de cercles, rectangles, triangles
- **3** : **Contours + Formes combinés** - Fusion intelligente des deux traitements

### Pipeline de Traitement
1. **Client** sélectionne le type via interface graphique
2. **Serveur** reçoit la commande et décide des traitements à appliquer
3. **Serveur** contrôle directement **Chai3D intégré** pour les algorithmes spécialisés
4. **Serveur** récupère le résultat de Chai3D et le distribue aux clients

## 🔄 Flux de Données

1. **Drone** capture vidéo et télémétrie, envoie au serveur
2. **Serveur** reçoit images brutes et commandes de traitement des clients
3. **Serveur** contrôle directement son **Chai3D intégré** selon les demandes :
   - Traitement 0 : Aucun traitement (image directe)
   - Traitement 1 : Algorithmes de détection de contours
   - Traitement 2 : Algorithmes de détection de formes  
   - Traitement 3 : Combinaison contours + formes
4. **Serveur** transmet images via FileMapping interne vers **Chai3D**
5. **Chai3D** applique les traitements spécialisés demandés par le serveur
6. **Chai3D** retourne images traitées au **Serveur** via FileMapping
7. **Serveur** distribue les images finales aux **Client(s)** via UDP
8. **Client** affiche les résultats et peut modifier les paramètres
9. **Communication bidirectionnelle continue** : **Client ↔ Serveur** 
   - Nouvelles commandes de traitement
   - Statuts et confirmations
   - Gestion d'enregistrement/désenregistrement des clients

## 🛠️ Dépendances

### Communes
- OpenCV 4.10.0 Java bindings
- Java UDP sockets
- Bibliothèques utilitaires communes

### Spécifiques au Serveur
- DLLs JNI pour FileMapping
- Interface Chai3D native
- Gestion multi-thread avancée

### Spécifiques au Drone
- Bibliothèques GPIO Raspberry Pi
- Drivers capteurs VL53L0X
- Gestion caméra Linux

## 📝 Documentation Détaillée

Consultez les README.md spécifiques dans chaque dossier :
- [Client README](client/README.md)
- [Serveur README](serveur/README.md)
- [Drone README](drone/README.md)

## 🐛 Dépannage

### Problèmes Courants
1. **Erreurs de socket null** : Normal en l'absence de connexions
2. **Crash JVM (serveur)** : Lié aux DLL natives, n'affecte pas le fonctionnement UDP
3. **Images noires** : Vérifier la connectivité réseau et les ports

### Logs
- Serveur : `hs_err_pid*.log` pour les crashes JVM
- Tous : Sortie console pour debug réseau

## 👥 Auteur

**BEAL JULIEN** - Version 3.0 - Mars 2025

## 📄 Licence

© 2025 BEAL JULIEN - Tous droits réservés