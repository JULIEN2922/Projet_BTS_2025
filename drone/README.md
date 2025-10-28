# Drone - Module de Capture et Télémétrie

## 📋 Description

Le module drone est conçu pour fonctionner sur un Raspberry Pi et constitue le point de capture du système. Il gère la caméra, les capteurs de télémétrie, les interfaces GPIO et transmet toutes les données via UDP vers le serveur de traitement.

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        DRONE (Raspberry Pi)                    │
│                                                                 │
│  ┌────────────────┐  ┌─────────────────┐  ┌─────────────────┐  │
│  │    Capture     │  │    Capteurs     │  │      GPIO       │  │
│  │     Vidéo      │  │   Télémétrie    │  │   & Hardware    │  │
│  │                │  │                 │  │                 │  │
│  │ ┌────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │
│  │ │  Caméra    │ │  │ │  VL53L0X    │ │  │ │ Distance    │ │  │
│  │ │  OpenCV    │ │  │ │ (Distance)  │ │  │ │ Tracker     │ │  │
│  │ └────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │  │
│  │                │  │                 │  │                 │  │
│  │ ┌────────────┐ │  │ ┌─────────────┐ │  │ ┌─────────────┐ │  │
│  │ │ Compression│ │  │ │  MPU6050    │ │  │ │ Serveur     │ │  │
│  │ │    JPEG    │ │  │ │(Gyro/Accel)│ │  │ │ GPIO Char   │ │  │
│  │ └────────────┘ │  │ └─────────────┘ │  │ └─────────────┘ │  │
│  │                │  │                 │  │                 │  │
│  │ ┌────────────┐ │  │ ┌─────────────┐ │  │                 │  │
│  │ │ Transmission│ │  │ │   BMP280    │ │  │                 │  │
│  │ │    UDP     │ │  │ │(Pression/T°)│ │  │                 │  │
│  │ └────────────┘ │  │ └─────────────┘ │  │                 │  │
│  │                │  │                 │  │                 │  │
│  │                │  │ ┌─────────────┐ │  │                 │  │
│  │                │  │ │    GNSS     │ │  │                 │  │
│  │                │  │ │ (Position)  │ │  │                 │  │
│  │                │  │ └─────────────┘ │  │                 │  │
│  └────────────────┘  └─────────────────┘  └─────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## 📁 Structure des Fichiers

### `/src/main/`
- **`drone_video.java`** : Gestion capture vidéo et transmission
- **`drone_telemetrie.java`** : Coordination capteurs et télémétrie

### `/src/capteurs/`
- **`CapteurGenerique.java`** : Interface générique pour tous capteurs
- **`I2C_Capteur.java`** : Classe de base pour capteurs I2C
- **`I2C_VL53L0X.java`** : Capteur de distance laser ToF
- **`I2C_MPU6050.java`** : Gyroscope/Accéléromètre 6 axes
- **`I2C_BMP280.java`** : Capteur pression atmosphérique/température
- **`I2C_GNSS.java`** : Module GPS/GNSS de position

### `/src/gpio/`
- **`Serveur_Char_GPIO.java`** : Interface GPIO pour communication
- **`DistanceTracker.java`** : Tracking et logging des distances

### `/src/thread/`
- **`thread_reception_string.java`** : Réception commandes UDP
- **`thread_list_dynamic_ip.java`** : Gestion adresses serveurs

### `/src/util/`
- **`tempo.java`** : Gestion temporisation
- **`error.java`** : Affichage erreurs et debug
- **`CustomClassLoader.java`** : Chargement dynamique de classes

### `/src/_start/`
- **`_start_drone.java`** : Point d'entrée principal

## 🔧 Configuration Matérielle

### Raspberry Pi Configuration
- **OS** : Raspberry Pi OS (Debian-based)
- **Java** : OpenJDK 17+
- **Caméra** : Camera Module V2/V3 ou USB
- **I2C** : Activé pour communication capteurs

### Capteurs Connectés

#### VL53L0X - Capteur de Distance Laser
- **Interface** : I2C
- **Portée** : 2mm à 2000mm
- **Précision** : ±3% jusqu'à 1m
- **Fréquence** : 50Hz max

#### MPU6050 - IMU 6 Axes
- **Interface** : I2C
- **Capteurs** : Gyroscope 3 axes + Accéléromètre 3 axes
- **Résolution** : 16 bits
- **Fréquence** : 100Hz

#### BMP280 - Pression/Température
- **Interface** : I2C
- **Mesures** : Pression atmosphérique (300-1100 hPa)
- **Température** : -40°C à +85°C
- **Résolution** : 0.16 Pa (pression)

#### GNSS - Positionnement Global
- **Interface** : I2C ou UART
- **Standards** : GPS, GLONASS, Galileo
- **Précision** : 3-5m (standard)

## 🔄 Flux de Données

### Capture Vidéo
1. **Acquisition** : OpenCV VideoCapture
2. **Compression** : JPEG qualité adaptative
3. **Transmission** : UDP vers port 55000 du serveur
4. **Fréquence** : 30 FPS cible

### Télémétrie
1. **Lecture capteurs** : Polling I2C périodique
2. **Agrégation données** : Formatage JSON/String
3. **Transmission** : UDP vers port 55003 du serveur
4. **Fréquence** : 10Hz pour télémétrie

### Communication Bidirectionnelle
- **Réception commandes** : Port 55002
- **Enregistrement serveur** : Auto-découverte et inscription

## 🚀 Configuration et Démarrage

### Prérequis Système
```bash
# Activation I2C
sudo raspi-config
# Interface Options > I2C > Enable

# Installation dépendances
sudo apt update
sudo apt install openjdk-17-jdk
sudo apt install libopencv-dev
```

### Permissions et Configuration
```bash
# Permissions GPIO/I2C
sudo usermod -a -G gpio,i2c $USER
sudo chmod 666 /dev/i2c-*
sudo chmod 666 /dev/gpiomem
```

### Variables d'Environnement
```bash
export LD_LIBRARY_PATH=./lib:./libs-VL53L0X:$LD_LIBRARY_PATH
```

### Compilation et Exécution
```bash
# Via script
chmod +x drone.sh
sudo ./drone.sh

# Ou manuellement
javac --release 17 -cp "lib/*:libs-VL53L0X/*" -d "bin" src/**/*.java
java -Djava.library.path="lib:libs-VL53L0X" -cp "lib/*:libs-VL53L0X/*:bin" _start._start_drone
```

## 📊 Protocoles de Données

### Format Télémétrie
```json
{
  "timestamp": "2025-03-17T14:30:00.000Z",
  "position": {
    "latitude": 45.7640,
    "longitude": 4.8357,
    "altitude": 525.5
  },
  "orientation": {
    "roll": 0.5,
    "pitch": -1.2,
    "yaw": 175.8
  },
  "sensors": {
    "distance_mm": 1250,
    "pressure_hpa": 1013.25,
    "temperature_c": 22.3,
    "acceleration": {
      "x": 0.1, "y": -0.05, "z": 9.81
    },
    "gyroscope": {
      "x": 0.02, "y": 0.01, "z": -0.003
    }
  }
}
```

### Communication UDP
```
D#telemetry?data#<JSON_DATA>?timestamp#<TIME>
D#status?state#<STATE>?battery#<LEVEL>
D#image_quality?compression#<RATE>?fps#<CURRENT_FPS>
```

## 🎯 Fonctionnalités

### Capture Vidéo Intelligente
- **Auto-adaptation qualité** : Selon bande passante
- **Compression dynamique** : JPEG 10-90% selon conditions
- **Gestion d'erreurs** : Fallback sur images statiques
- **Monitoring FPS** : Adaptation temps réel

### Télémétrie Complète
- **Fusion capteurs** : Données cohérentes multi-sources
- **Calibration automatique** : Offset et drift compensation
- **Détection pannes** : Validation croisée capteurs
- **Logging local** : Sauvegarde données critiques

### Communication Robuste
- **Auto-découverte serveur** : Scan réseau et connexion automatique
- **Reconnexion automatique** : Gestion des déconnexions
- **Buffering intelligent** : Gestion des pertes réseau temporaires
- **Compression adaptative** : Optimisation bande passante

## 🔧 Dépendances

### Bibliothèques Java
- **OpenCV 4.10.0** : `opencv-4100.jar` + natives
- **Pi4J** : Accès GPIO Raspberry Pi (si utilisé)
- **JNI natives** : Interfaces capteurs custom

### Bibliothèques Natives
- **libopencv_*.so** : OpenCV natives Linux ARM
- **VL53L0X libraries** : `libs-VL53L0X/` - Driver capteur laser
- **I2C natives** : Accès bus I2C système

### Dépendances Système
- **i2c-tools** : Debug et configuration I2C
- **v4l-utils** : Configuration caméra Video4Linux
- **gpio utilities** : Accès GPIO système

## 🐛 Diagnostic et Debug

### Vérification Capteurs
```bash
# Scan I2C
sudo i2cdetect -y 1

# Test caméra
v4l2-ctl --list-devices

# Test GPIO
gpio readall
```

### Logs et Monitoring
- **Console output** : Debug temps réel capture/transmission
- **Fichiers logs** : Historique télémétrie et erreurs
- **Monitoring réseau** : Statistiques transmission UDP

### Problèmes Courants

#### Capteurs Non Détectés
```bash
# Vérifier I2C actif
sudo raspi-config
# Vérifier connexions physiques
sudo i2cdetect -y 1
```

#### Permissions Caméra/GPIO
```bash
# Ajout groupes utilisateur
sudo usermod -a -G video,gpio $USER
# Redémarrage requis
sudo reboot
```

#### Problèmes Réseau
- Vérifier configuration IP statique
- Tester connectivité ping vers serveur
- Contrôler pare-feu et ports ouverts

## 🎮 Modes de Fonctionnement

### Mode Production
- Tous capteurs actifs
- Transmission continue
- Qualité optimisée pour bande passante

### Mode Debug
- Logs verbeux activés
- Données simulées disponibles
- Interface de test intégrée

### Mode Économie
- Réduction fréquence capture
- Compression maximale
- Capteurs non-critiques désactivés

## 📈 Performances

### Optimisations
- **Threading** : Capture et transmission parallèles
- **Buffers circulaires** : Minimisation copies mémoire
- **Compression adaptative** : Équilibre qualité/bande passante
- **Pooling objets** : Réduction garbage collection

### Métriques Typiques
- **FPS vidéo** : 15-30 fps selon qualité
- **Latence télémétrie** : <100ms
- **Bande passante** : 1-5 Mbps selon compression
- **CPU Usage** : 30-60% sur Raspberry Pi 4

## 💾 Configuration Avancée

### Paramètres Caméra
```java
// Résolution et FPS configurables
videoCapture.set(Videoio.CAP_PROP_FRAME_WIDTH, 1280);
videoCapture.set(Videoio.CAP_PROP_FRAME_HEIGHT, 720);
videoCapture.set(Videoio.CAP_PROP_FPS, 30);
```

### Calibration Capteurs
- **MPU6050** : Offset gyroscope et accéléromètre
- **BMP280** : Calibration pression niveau mer
- **VL53L0X** : Calibration offset distance
- **GNSS** : Configuration constellation et précision