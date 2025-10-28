# Serveur - Hub de Traitement d'Image et Coordination

## 📋 Description

Le serveur constitue le cœur du système de drone. Il reçoit les images brutes du drone, applique les traitements d'image demandés, coordonne les communications entre tous les modules et interface avec l'environnement de réalité virtuelle Chai3D.

## 🏗️ Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                        SERVEUR                                │
│                                                               │
│  ┌──────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │   Threads    │  │   Traitement    │  │   FileMapping   │  │
│  │  Réseau UDP  │  │    Images       │  │    Chai3D      │  │
│  │              │  │                 │  │                 │  │
│  │ ┌──────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │
│  │ │Réception │ │  │ │ Détection   │ │  │ │ Serveur     │ │  │
│  │ │ Images   │ │  │ │ Contours    │ │  │ │ Picture     │ │  │
│  │ └──────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │  │
│  │              │  │                 │  │                 │  │
│  │ ┌──────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │
│  │ │ Envoi    │ │  │ │ Détection   │ │  │ │ Client      │ │  │
│  │ │ Images   │ │  │ │ Formes      │ │  │ │ Picture     │ │  │
│  │ └──────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │  │
│  │              │  │                 │  │                 │  │
│  │ ┌──────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │
│  │ │Commandes │ │  │ │ Combinaison │ │  │ │ Télémétrie  │ │  │
│  │ │& Status  │ │  │ │ Traitements │ │  │ │ FileMapping │ │  │
│  │ └──────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │  │
│  └──────────────┘  └─────────────────┘  └─────────────────┘  │
└───────────────────────────────────────────────────────────────┘
```

## 📁 Structure des Fichiers

### Fichiers Principaux
- **`traitement.java`** : Classe principale, orchestration complète
- **`_start_traitement.java`** : Point d'entrée du programme

### `/src/thread/`
- **`thread_reception_image.java`** : Réception images UDP du drone
- **`thread_reception_string.java`** : Réception commandes UDP des clients
- **`thread_detection_contours.java`** : Traitement détection de contours
- **`thread_detection_formes.java`** : Traitement détection de formes
- **`thread_envoie_cmd.java`** : Envoi commandes UDP et auto-enregistrement
- **`thread_list_dynamic_ip.java`** : Gestion liste clients dynamique
- **`thread_traitement_telemtrie.java`** : Traitement télémétrie drone

### `/src/util/`
- **`FenetreTraitement.java`** : Interface graphique de contrôle serveur
- **`TelemetryClientGUI.java`** : Interface télémétrie (si utilisée)
- **`tempo.java`** : Utilitaires temporisation
- **`error.java`** : Gestion erreurs et affichage ASCII

### Fichiers JNI (FileMapping)
- **`cFileMappingPictureClient.java`** : Interface client FileMapping images
- **`cFileMappingPictureServeur.java`** : Interface serveur FileMapping images
- **`cFileMappingDroneCharTelemetryServeur.java`** : FileMapping télémétrie
- **`cVirtualPicture.java`** : Interface images virtuelles
- **`cVirtualDroneCharTelemetry.java`** : Interface télémétrie virtuelle

## 🔧 Configuration Réseau

### Ports UDP
- **55000** : Réception images du drone
- **55001** : Envoi images vers clients
- **55002** : Réception/envoi commandes clients
- **55003** : Réception télémétrie drone

### Auto-configuration
- Détection automatique adresse IP locale (172.29.x.x)
- Configuration automatique des sockets UDP
- Enregistrement automatique sur le réseau

## 🎯 Types de Traitement

### Traitement 0 : Image Originale
- Aucun traitement appliqué
- Image directement transmise

### Traitement 1 : Détection de Contours
- Algorithme Canny d'OpenCV
- Seuils adaptatifs
- Optimisé pour temps réel

### Traitement 2 : Détection de Formes
- Reconnaissance de formes géométriques
- Cercles, rectangles, triangles
- Annotation visuelle

### Traitement 3 : Combiné
- Fusion contours + formes
- Addition des différences
- Superposition intelligente

## 🔄 Flux de Données

### Réception (Drone → Serveur)
1. **Images** : Port 55000, format JPEG compressé
2. **Télémétrie** : Port 55003, données capteurs

### Traitement
1. **Sélection algorithme** : Selon commandes clients/interface
2. **Application traitement** : Threads dédiés OpenCV
3. **Optimisation qualité** : Compression adaptive

### Diffusion (Serveur → Clients)
1. **Images traitées** : Port 55001 vers tous clients
2. **Statuts** : Port 55002, confirmations et états

### Interface Chai3D
1. **FileMapping sortant** : Images vers environnement 3D
2. **FileMapping entrant** : Données processed de Chai3D
3. **Synchronisation** : Mutex pour accès concurrent

## 🚀 Démarrage et Initialisation

### Séquence de Démarrage
1. **Chargement bibliothèques natives** : DLLs JNI
2. **Configuration réseau** : Détection IP et création sockets
3. **Initialisation FileMapping** : Serveur et client mappings
4. **Lancement threads** : Tous les threads de traitement
5. **Interface graphique** : Fenêtres de contrôle
6. **Démarrage Chai3D** : Lancement automatique 00-drone-ju.exe
7. **Boucle principale** : Coordination et traitement

### Gestion de l'Exécutable Chai3D
```java
// Chemin corrigé vers l'exécutable
Path exeRelative = Paths.get("..", "..", "00-drone-ju.exe");
ProcessBuilder pb = new ProcessBuilder(exePath.toString());
process = pb.start();
```

## 🎮 Interfaces Graphiques

### Fenêtre "drone" (0, 0)
- Affichage des images reçues du drone
- Contrôles de traitement locaux
- Monitoring de la réception

### Fenêtre "traitement" (640, 0)
- Affichage des images après traitement
- Contrôles de traitement serveur
- Validation des algorithmes

## 📊 Gestion Multi-Clients

### Liste Dynamique des Clients
- **Ajout automatique** : `C#add?address#<IP>?time#<TIMESTAMP>`
- **Suppression** : `C#remove?address#<IP>`
- **Mise à jour** : `C#cmd?address#<IP>?time#<TIMESTAMP>?traitement#<TYPE>`

### Priorisation des Commandes
1. **Client le plus récent** : Basé sur timestamp
2. **Interface drone** : Priorité locale
3. **Interface serveur** : Contrôle direct

### Distribution des Images
- Envoi simultané vers tous les clients enregistrés
- Compression adaptative selon charge réseau
- Gestion des échecs de transmission

## 🔧 Optimisations Performances

### Compression Adaptative
```java
int quality = 70;
do {
    encodedData = encodeImageToJPEG(imageEnvoyer, quality);
    quality -= 5;
} while (encodedData.length > maxPacketSize && quality > 10);
```

### Gestion Mémoire
- Libération explicite objets OpenCV
- Réutilisation des buffers
- Garbage collection optimisé

### Threading
- Threads dédiés par fonction
- Synchronisation minimale
- Load balancing automatique

## 🛡️ Gestion d'Erreurs

### Erreurs de Communication
- **Socket null** : Réinitialisation automatique
- **Timeouts UDP** : Retry avec backoff
- **Adresses invalides** : Nettoyage liste clients

### Erreurs de Traitement
- **Images corrompues** : Image noire de fallback
- **Échecs OpenCV** : Bypass vers image originale
- **Surcharge mémoire** : Réduction qualité automatique

### Erreurs JNI/FileMapping
- **DLL manquantes** : Dégradation gracieuse
- **Corruptions mémoire** : Redémarrage composants
- **Chai3D crash** : Relance automatique process

## 🔧 Dépendances Techniques

### Bibliothèques Java
- **OpenCV 4.10.0** : Traitement d'image principal
- **Swing** : Interfaces graphiques
- **NIO** : Gestion fichiers et processus

### Bibliothèques Natives (JNI)
- **JNIFileMappingPictureClient.dll**
- **JNIFileMappingPictureServeur.dll**
- **JNIVirtualPicture.dll**
- **JNIFileMappingDroneCharTelemetryServeur.dll**
- **JNIVirtualDroneCharTelemetry.dll**
- **opencv_java4100.dll**

### Exécutable Externe
- **00-drone-ju.exe** : Application Chai3D pour VR

## 💻 Utilisation

### Compilation
```bash
javac -cp "lib/opencv-4100.jar" -d "bin" src/thread/*.java src/util/*.java src/*.java
```

### Exécution
```bash
java -Djava.library.path="lib" -cp "lib/opencv-4100.jar;bin" _start_traitement
```

### Script de Lancement
```bash
./traitement.bat
```

## 📈 Monitoring et Debug

### Informations Affichées
- **FPS en temps réel** : Performance de traitement
- **État des connexions** : Nombre de clients connectés
- **Statut Chai3D** : État du processus VR
- **Métriques réseau** : Bande passante et latence

### Logs et Diagnostics
- **Console output** : Debug temps réel
- **Crash logs** : `hs_err_pid*.log` pour JVM crashes
- **Monitoring FileMapping** : États des mutex et données

## 🎯 Cas d'Usage

### Opération Normale
1. Drone envoie stream video continu
2. Clients se connectent et demandent traitements
3. Serveur applique algorithmes et redistribue
4. Chai3D affiche en réalité virtuelle

### Mode Debug
1. Interfaces locales pour test algorithmes
2. Injection d'images statiques
3. Validation des traitements sans drone

### Mode Démonstration
1. Images de test intégrées
2. Tous traitements disponibles
3. Interface complète sans matériel