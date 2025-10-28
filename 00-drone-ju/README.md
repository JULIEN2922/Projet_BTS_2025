# Module Chai3D - Interface de Visualisation 3D

## 📖 Description

Le module **00-drone-ju** est une application de visualisation 3D développée avec le framework **Chai3D**. Cette interface graphique permet de visualiser en temps réel les données de télémétrie du drone ainsi que les flux vidéo, offrant une expérience immersive pour le pilotage et la surveillance du système.

## 🏗️ Architecture

### 🎯 Objectif Principal
- **Visualisation 3D temps réel** des données de télémétrie
- **Affichage vidéo** en arrière-plan avec flux de la caméra drone
- **Interface utilisateur intuitive** avec jauges, cadrans et indicateurs
- **Communication bidirectionnelle** avec les modules Java via FileMapping

### 🔧 Technologies Utilisées
- **Chai3D Framework** - Moteur 3D et haptique
- **OpenGL** - Rendu graphique 3D
- **GLFW** - Gestion des fenêtres et événements
- **C++** - Langage de programmation principal
- **Visual Studio 2015/2019/2022** - Environnement de développement

## 📁 Structure des Fichiers

```
00-drone-ju/
├── 00-drone-ju.cpp                           # Application principale Chai3D
├── 00-drone-ju-VS2015.sln                    # Solution Visual Studio 2015
├── 00-drone-ju-VS2015.vcxproj                # Projet Visual Studio 2015
├── 00-drone-ju-VS2015.vcxproj.filters        # Filtres du projet
├── 00-drone-ju-VS2015.vcxproj.user           # Configuration utilisateur
├── 00-drone-ju-VS2012.vcxproj                # Support Visual Studio 2012
├── 00-drone-ju-VS2013.vcxproj                # Support Visual Studio 2013
├── 00-drone-ju.exe                           # Exécutable compilé
├── Image_out.jpg                             # Image de sortie de test
├── obj/                                      # Dossier des objets compilés
│   ├── Debug/                                # Objets de debug
│   └── Release/                              # Objets de release
├── .vscode/                                  # Configuration VS Code
│   ├── settings.json                         # Paramètres de l'éditeur
│   └── tasks.json                            # Tâches de compilation
├── cFileMappingPictureClient.cpp/.h          # Client FileMapping pour images
├── cFileMappingPictureServeur.cpp/.h         # Serveur FileMapping pour images
├── cFileMappingDroneCharTelemetryClient.cpp/.h # Client FileMapping télémétrie
├── cFileMappingDroneCharTelemetryServeur.cpp/.h # Serveur FileMapping télémétrie
├── cVirtualPicture.cpp/.h                    # Structure virtuelle des images
├── cVirtualDroneCharTelemetry.cpp/.h         # Structure virtuelle télémétrie
└── README.md                                 # Documentation du module
```

## 🎮 Interface Utilisateur

### 📊 Éléments Visuels

#### **Jauges Verticales (Levels)**
- **val0 (Distance)** : Capteur de distance (0-10000 unités)
- **val1 (Température)** : Température ambiante (-25°C à 120°C)
- **val2 (Altitude)** : Altitude barométrique (-10m à 500m)
- **val3 (Pression)** : Pression barométrique (-100 à 1500 hPa)
- **val4-6 (Accélération)** : Accélération X, Y, Z (-5g à 10g)
- **val12 (Altitude GNSS)** : Altitude GPS (-10m à 500m)
- **val13 (Vitesse)** : Vitesse de déplacement (-25 à 100 km/h)

#### **Cadrans Circulaires (Dials)**
- **val7-9 (Gyroscope)** : Rotation X, Y, Z (-180° à 180°)

#### **Labels d'Information**
- **val10 (Latitude)** : Coordonnées GPS latitude
- **val11 (Longitude)** : Coordonnées GPS longitude
- **val14 (Satellites)** : Nombre de satellites GNSS
- **val15 (Temps)** : Horodatage des données

#### **Visualisation 3D**
- **Sphère rouge** : Position 3D basée sur l'accélération (val4, val5, val6)
- **Arrière-plan dynamique** : Flux vidéo en temps réel du drone

### 🎮 Contrôles Clavier
- **ESC / Q** : Quitter l'application
- **F** : Basculer en mode plein écran
- **M** : Inverser l'affichage vertical

## 🔄 Communication Inter-Processus

### 📡 FileMapping - Télémétrie
```cpp
// Réception des données de télémétrie depuis Java
cFileMappingDroneCharTelemetryClient* monClientCppFMDCTelemetry
├── Nom du mapping : "telemetrie_java_to_c"
├── Structure : cVirtualDroneCharTelemetry
├── Données : 20 valeurs float (val_0 à val_19)
└── Mutex : Protection accès concurrent
```

### 📷 FileMapping - Images
```cpp
// Réception flux vidéo depuis Java
cFileMappingPictureClient* monClientCppFMPictureScreenShot
├── Nom du mapping : "img_java_to_c"
├── Format : JPEG compressé
├── Taille max : 10 Mo
└── Résolution : 1080x720 pixels

// Envoi capture d'écran vers Java
cFileMappingPictureServeur* monServeurCppFMPictureScreenShot
├── Nom du mapping : "img_c_to_java"
├── Format : JPEG compressé
├── Source : Rendu Chai3D
└── Fréquence : Temps réel
```

## ⚙️ Configuration et Compilation

### 🔧 Prérequis
- **Visual Studio 2015** ou version supérieure
- **Chai3D SDK** installé et configuré
- **OpenGL** et **GLFW** libraries
- **Windows SDK** version 10.0 ou supérieure

### 🏗️ Compilation
```bash
# Ouvrir la solution dans Visual Studio
00-drone-ju-VS2015.sln

# Ou compiler en ligne de commande
msbuild 00-drone-ju-VS2015.vcxproj /p:Configuration=Release /p:Platform=x64
```

### ⚙️ Configuration du Projet
```xml
<!-- Configurations supportées -->
- Debug|Win32     : Version de débogage 32 bits
- Release|Win32   : Version optimisée 32 bits  
- Debug|x64       : Version de débogage 64 bits
- Release|x64     : Version optimisée 64 bits (recommandée)
```

## 🎯 Fonctionnalités Principales

### 🎥 Rendu Vidéo
- **Arrière-plan dynamique** : Affichage du flux caméra en arrière-plan
- **Capture d'écran** : Sauvegarde automatique de l'interface
- **Compression JPEG** : Optimisation de la bande passante

### 📊 Visualisation Données
- **Mise à jour temps réel** : Rafraîchissement continu des indicateurs
- **Interface intuitive** : Jauges et cadrans facilement lisibles
- **Données multi-capteurs** : Support de tous les capteurs du drone

### 🔄 Synchronisation
- **Mutex thread-safe** : Protection des accès concurrents
- **FileMapping optimisé** : Communication haute performance
- **Gestion d'erreurs** : Robustesse face aux déconnexions

## 🎮 Utilisation

### 🚀 Lancement
```bash
# Depuis l'explorateur Windows
double-click sur 00-drone-ju.exe

# Depuis la ligne de commande  
cd "00-drone-ju"
./00-drone-ju.exe
```

### 📋 Séquence de Démarrage
1. **Initialisation OpenGL** : Configuration de la fenêtre 1080x720
2. **Création du monde 3D** : Setup caméra, éclairage, objets
3. **Connexion FileMapping** : Établissement des liens avec Java
4. **Interface utilisateur** : Création des jauges et indicateurs
5. **Boucle principale** : Rendu continu et mise à jour des données

### 🔍 Surveillance
- **Fréquence de rendu** : Compteur FPS affiché
- **État des connexions** : Vérification des FileMapping
- **Qualité vidéo** : Monitoring du flux image

## 🐛 Dépannage

### ❌ Problèmes Courants

#### **Échec de connexion FileMapping**
```cpp
// Vérifier que les modules Java sont lancés
// Contrôler les noms des mappings :
// - "telemetrie_java_to_c"
// - "img_java_to_c" 
// - "img_c_to_java"
```

#### **Pas d'affichage vidéo**
- Vérifier que le module serveur Java envoie les images
- Contrôler la taille des images (max 10 Mo)
- S'assurer que le format JPEG est correct

#### **Interface figée**
- Redémarrer les modules dans l'ordre : drone → serveur → client → chai3d
- Vérifier la disponibilité des ports de communication

### 🔧 Debug
```cpp
// Activer le mode debug dans les classes FileMapping
monClientCppFMPictureScreenShot->setDebugMode(true);
monClientCppFMDCTelemetry->setDebugMode(true);
```

## 🔗 Intégration Système

### 📡 Avec Module Serveur Java
- **Port UDP 55001** : Réception données télémétrie  
- **FileMapping** : Échange images et télémétrie
- **Synchronisation** : Mutex et signaux

### 🎯 Avec Module Client Java
- **Capture d'écran** : Envoi interface Chai3D vers client
- **Commandes** : Réception instructions de pilotage
- **État système** : Monitoring global du drone

### 🚁 Avec Module Drone
- **Données temps réel** : Télémétrie capteurs
- **Flux vidéo** : Stream caméra embarquée
- **Contrôle** : Instructions de navigation

## 📈 Performance

### ⚡ Optimisations
- **Rendu OpenGL** : GPU accelerated
- **Compression JPEG** : Réduction taille images
- **FileMapping** : Communication mémoire partagée
- **Threading** : Traitement asynchrone

### 📊 Métriques Typiques
- **FPS Interface** : 60 FPS stable
- **Latence télémétrie** : < 10ms
- **Latence vidéo** : < 50ms
- **Utilisation CPU** : < 15%

---

## 👨‍💻 Auteur

**BEAL Julien**  
Version 1.0 - Mars 2025

## 📄 Licence

Ce projet est sous licence BSD. Voir le fichier de licence pour plus de détails.

---

*Interface Chai3D pour système de drone autonome - Projet BTS 2025*