# Client - Interface de Visualisation et Contrôle

## 📋 Description

Le module client fournit une interface graphique Java pour visualiser les flux vidéo traités et contrôler les paramètres de traitement d'image du système de drone. Il agit comme un point de contrôle et de surveillance pour les opérateurs.

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│              CLIENT                     │
│                                         │
│  ┌─────────────────┐  ┌───────────────┐ │
│  │ FenetreTraitement│  │    Threads    │ │
│  │   (Interface)   │  │   UDP/Network │ │
│  │                 │  │               │ │
│  │ ┌─────────────┐ │  │ ┌───────────┐ │ │
│  │ │ Boutons     │ │  │ │ Réception │ │ │
│  │ │ Contrôle    │ │  │ │ Images    │ │ │
│  │ └─────────────┘ │  │ └───────────┘ │ │
│  │                 │  │               │ │
│  │ ┌─────────────┐ │  │ ┌───────────┐ │ │
│  │ │ Affichage   │ │  │ │ Envoi     │ │ │
│  │ │ Vidéo       │ │  │ │ Commandes │ │ │
│  │ │ Temps Réel  │ │  │ └───────────┘ │ │
│  │ └─────────────┘ │  │               │ │
│  └─────────────────┘  └───────────────┘ │
└─────────────────────────────────────────┘
```

## 📁 Structure des Fichiers

### `/src/main/`
- **`client.java`** : Classe principale, gestion réseau et coordination

### `/src/thread/`
- **`thread_reception_image.java`** : Réception des images UDP
- **`thread_reception_string.java`** : Réception des messages/commandes
- **`thread_envoie_cmd.java`** : Envoi des commandes vers le serveur
- **`thread_list_dynamic_ip.java`** : Gestion des adresses IP dynamiques

### `/src/util/`
- **`FenetreTraitement.java`** : Interface graphique Swing
- **`tempo.java`** : Gestion des délais et temporisation
- **`error.java`** : Affichage d'erreurs et logos ASCII

### `/src/_start/`
- **`_start_client.java`** : Point d'entrée principal

## 🔧 Configuration Réseau

### Adresses et Ports
- **Port 55001** : Réception des images traitées
- **Port 55002** : Réception/envoi des commandes
- **Broadcast** : 172.29.255.255
- **Réseau local** : 172.29.41.x

### Auto-configuration
Le client détecte automatiquement son adresse IP locale dans le sous-réseau 172.29.41.x et s'enregistre auprès du serveur.

## 🎮 Interface Utilisateur

### Fenêtre Principale (640x550)
- **Zone d'affichage** : Flux vidéo en temps réel (320x180)
- **Panneau de contrôle** : 4 boutons de traitement
- **Affichage FPS** : Information de performance

### Boutons de Contrôle
1. **"rien"** (Traitement 0) : Image originale sans traitement
2. **"contours"** (Traitement 1) : Détection de contours seulement  
3. **"formes"** (Traitement 2) : Détection de formes géométriques
4. **"formes et contours"** (Traitement 3) : Combinaison des deux

## 🔄 Fonctionnement

### Démarrage
1. Détection de l'adresse IP locale
2. Ouverture des sockets UDP (ports 55001 et 55002)
3. Lancement des threads de communication
4. Création de l'interface graphique
5. Enregistrement automatique auprès du serveur

### Boucle Principale
1. **Réception d'images** : Décodage JPEG via OpenCV
2. **Affichage** : Conversion BufferedImage et rafraîchissement GUI
3. **Gestion des commandes** : Envoi des changements de traitement
4. **Calcul FPS** : Mesure et affichage des performances

### Arrêt Propre
- Hook de fermeture pour désenregistrement du serveur
- Fermeture des sockets et threads
- Nettoyage des ressources

## 📊 Protocole de Communication

### Messages Envoyés
```
C#add?address#<IP_CLIENT>?time#<TIMESTAMP>
C#remove?address#<IP_CLIENT>
C#cmd?address#<IP_CLIENT>?time#<TIMESTAMP>?traitement#<TYPE>
```

### Messages Reçus
- **Images JPEG** : Flux vidéo compressé via UDP
- **Commandes** : Statuts et confirmations du serveur

## 🚀 Utilisation

### Compilation et Exécution
```bash
# Compilation
javac -cp "lib/opencv-4100.jar" -d "bin" src/_start/*.java src/thread/*.java src/util/*.java src/main/*.java

# Exécution  
java -Djava.library.path="lib" -cp "lib/opencv-4100.jar;bin" _start._start_client
```

### Script de Lancement
```bash
./client.bat
```

## 🎯 Fonctionnalités

### Affichage Temps Réel
- **Décodage JPEG** : OpenCV pour performance optimale
- **Redimensionnement** : Images adaptées à l'interface
- **FPS Counter** : Monitoring des performances réseau

### Contrôle Interactif
- **Changement instantané** : Modification des traitements en temps réel
- **Feedback visuel** : État des boutons et confirmations
- **Multi-client** : Plusieurs clients peuvent coexister

### Gestion Réseau
- **Auto-découverte** : Détection automatique de l'IP locale
- **Reconnexion** : Gestion des déconnexions réseau
- **Broadcast** : Communication avec tous les serveurs disponibles

## 🐛 Gestion d'Erreurs

### Erreurs Réseau
- **Socket null** : Normal au démarrage, avant connexion serveur
- **Timeout UDP** : Reconnexion automatique
- **Adresse introuvable** : Vérification de la configuration réseau

### Erreurs d'Affichage
- **Image corrompue** : Affichage d'une image noire par défaut
- **Décodage JPEG** : Gestion des erreurs OpenCV
- **GUI non-responsive** : Séparation threads affichage/réseau

## 📈 Performances

### Optimisations
- **Threads séparés** : Réception/affichage non-bloquants
- **Compression JPEG** : Transmission optimisée
- **Buffers partagés** : Minimisation des copies mémoire

### Monitoring
- **FPS affiché** : Performance en temps réel
- **Logs console** : Debug des communications réseau
- **Métriques réseau** : Monitoring de la bande passante

## 🔧 Dépendances

### Bibliothèques Java
- **OpenCV 4.10.0** : `opencv-4100.jar`
- **Swing** : Interface graphique native Java
- **Java Sockets** : Communication UDP

### Bibliothèques Natives
- **OpenCV natives** : `opencv_java4100.dll`
- **Codecs images** : Support JPEG intégré

## 💡 Notes Techniques

### Thread Safety
- Synchronisation via objets partagés
- Gestion des accès concurrents aux images
- Protection des variables d'état

### Mémoire
- Libération automatique des objets OpenCV
- Gestion du garbage collector Java
- Optimisation des allocations BufferedImage

## 👥 Maintenance

### Logs et Debug
- Sortie console pour debug réseau
- Gestion des exceptions avec stack traces
- Monitoring des performances FPS

### Configuration
- Paramètres réseau en dur (modifiables dans le code)
- Chemins des bibliothèques configurables
- Tailles d'interface ajustables