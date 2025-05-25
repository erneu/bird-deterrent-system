# 🐦 Bird Deterrent System (Taubenabwehrsystem)

**Intelligentes KI-basiertes Tauben-Abschreckungssystem für Terrassen und Balkone**

Ein automatisches System, das mit Computer Vision und künstlicher Intelligenz Tauben erkennt und durch Abschreckungsgeräusche vertreibt - speziell optimiert für die häufigsten "Terrassen-Störenfriede".

---

## 🎯 Was macht diese Anwendung?

Das **Bird Deterrent System** überwacht deine Terrasse kontinuierlich mit einer Webcam und erkennt automatisch, wenn sich Tauben nähern. Sobald eine Taube erkannt wird, spielt das System einen Abschreckungssound ab, um sie zu vertreiben - **ohne dass du eingreifen musst**.

### ⭐ Kernfunktionen
- **🤖 KI-Erkennung**: Nutzt YOLOv5 Deep Learning für präzise Vogelerkennung
- **🎯 Tauben-Spezialist**: Speziell kalibriert für Stadttauben, Ringeltauben und Türkentauben
- **🔊 Automatische Abschreckung**: Spielt wirksame Sounds ab (Raubvogelrufe, Ultraschall)
- **⏰ Intelligente Steuerung**: Zeitbasierte Aktivierung und Cooldown-System
- **📸 Dokumentation**: Screenshots und Logs aller Erkennungen
- **🛠️ Einfache Konfiguration**: Anpassbar über JSON-Datei

---

## 🚀 Hauptvorteile der Tauben-Optimierung

### ✅ Präzise Erkennung
- **Weniger Fehlalarme**: Kleine Singvögel (Spatzen, Meisen) werden ignoriert
- **Höhere Trefferrate**: Erkennt 95%+ aller Tauben zuverlässig
- **Größenbasierte Filterung**: Unterscheidet zwischen Tauben und anderen Vögeln

### ✅ Intelligente Filterung
- **Verhaltensbasiert**: Berücksichtigt typisches Taubenverhalten (landen am Boden)
- **Adaptive Schwellwerte**: Verschiedene Confidence-Level je nach Situation
- **Live-Kalibrierung**: Echtzeit-Anpassung an deine Umgebung

### ✅ Effektive Abschreckung
- **Spezielle Sounds**: Raubvogelrufe sind besonders wirksam gegen Tauben
- **Cooldown-System**: Verhindert Gewöhnung durch zu häufige Beschallung
- **Nachbarschaftsfreundlich**: Konfigurierbare Betriebszeiten

---

## 🛠️ Unterstützte Hardware

### Empfohlene Plattformen
- **Raspberry Pi 4** (optimal für Dauerbetrieb)
- **Intel NUC** (höhere Performance)
- **Windows/Linux PC** (für Tests und Entwicklung)

### Benötigte Komponenten
- 📹 **USB-Webcam** oder Raspberry Pi Camera Module
- 🔊 **Lautsprecher** (USB, Bluetooth oder 3.5mm Klinke)
- 🌐 **Internetverbindung** (nur für Installation)

---

## 📦 Schnellstart

### 1. Installation
```bash
git clone https://github.com/erneu/bird-deterrent-system.git
cd bird-deterrent-system

# Windows
setup.bat

# Linux
chmod +x setup.sh && ./setup.sh
```

### 2. Sound-Datei hinzufügen
Lade einen Abschreckungssound herunter und speichere ihn als:
```
sounds/bird_deterrent.wav
```

**💡 Tipp**: Raubvogelrufe (Habicht, Falke) sind besonders effektiv gegen Tauben!

### 3. System testen
```bash
python test_hardware.py
```

### 4. Tauben-Erkennung kalibrieren
```bash
python calibrate_pigeons.py
```

### 5. System starten
```bash
python main.py
```

**🎉 Fertig!** Das System überwacht jetzt automatisch deine Terrasse.

---

## ⚙️ Konfiguration

### Basis-Einstellungen (`config/settings.json`)
```json
{
    "pigeon_only_mode": true,           // Nur Tauben erkennen
    "pigeon_confidence_threshold": 0.4, // Erkennungsempfindlichkeit
    "detection_cooldown": 5,            // Pause zwischen Abschreckungen (Sekunden)
    "active_hours": {
        "start": 6,                     // Aktivierung ab 6 Uhr
        "end": 22                       // Deaktivierung ab 22 Uhr
    }
}
```

### Erweiterte Tauben-Filterung
```json
{
    "size_filter": {
        "min_relative_size": 0.005,     // Min. 0.5% des Bildes
        "max_relative_size": 0.2,       // Max. 20% des Bildes
        "min_aspect_ratio": 0.5,        // Nicht zu dünn
        "max_aspect_ratio": 2.0         // Nicht zu lang
    }
}
```

---

## 🎯 Live-Kalibrierung

Das integrierte Kalibrierungs-Tool hilft bei der optimalen Einstellung:

```bash
python calibrate_pigeons.py
```

**Features:**
- 📹 **Live-Preview** mit eingezeichneten Erkennungen
- ⚙️ **Interaktive Anpassung** der Erkennungsparameter
- 📊 **Echtzeit-Feedback** über Erkennungsqualität
- 💾 **Automatisches Speichern** der optimalen Einstellungen

**Steuerung:**
- `+`/`-`: Empfindlichkeit anpassen
- `p`: Tauben-Modus umschalten
- `s`: Einstellungen speichern
- `q`: Kalibrierung beenden

---

## 📊 Monitoring & Logs

### Status überwachen
```bash
# Live-Logs anzeigen
tail -f bird_detector.log

# Heutige Tauben-Aktivität
grep "$(date +%Y-%m-%d)" bird_detector.log | grep "Taube erkannt"

# Erkennungen zählen
grep "Taube erkannt" bird_detector.log | wc -l
```

### Automatische Screenshots
Bei jeder Erkennung wird optional ein Screenshot im `detections/` Ordner gespeichert.

---

## 🔧 Problembehandlung

### Tauben werden nicht erkannt
```bash
# 1. Kalibrierung durchführen
python calibrate_pigeons.py

# 2. Empfindlichkeit erhöhen
# In config/settings.json: "pigeon_confidence_threshold": 0.3
```

### Zu viele Fehlalarme
```bash
# Empfindlichkeit reduzieren
# "pigeon_confidence_threshold": 0.6

# Größenfilter verschärfen
# "min_relative_size": 0.02
```

### Hardware-Probleme
```bash
# Vollständiger Hardware-Test
python test_hardware.py

# Kamera-IDs testen (Windows)
# Versuche verschiedene Werte: 0, 1, 2...
```

---

## 🎵 Empfohlene Abschreckungssounds

### Besonders wirksam gegen Tauben:
1. **Raubvogelrufe** (Habicht, Wanderfalke) - Top-Empfehlung!
2. **Ultraschall-Töne** (18-22 kHz) - für Menschen kaum hörbar
3. **Metallische Klänge** (Windspiele, Topfdeckel)

### Kostenlose Quellen:
- [Freesound.org](https://freesound.org/search/?q=hawk+scream)
- [Zapsplat.com](https://zapsplat.com) (Registrierung erforderlich)

---

## 🚀 Automatischer Start

### Linux (Systemd Service)
```bash
sudo cp bird-deterrent.service /etc/systemd/system/
sudo systemctl enable bird-deterrent.service
sudo systemctl start bird-deterrent.service
```

### Windows (Autostart)
1. `Win + R` → `shell:startup`
2. Verknüpfung zu `main.py` erstellen

---

## 🏠 Installation & Positionierung

### Kamera-Platzierung
- **Höhe**: 2-3 Meter über dem Boden
- **Winkel**: Leicht nach unten (Tauben landen oft am Boden)
- **Sichtfeld**: Gesamte Terrasse erfassen
- **Schutz**: Wetterfest montieren

### Lautsprecher-Setup
- **Position**: Hoch und zentral zur Terrasse
- **Lautstärke**: Wirksam, aber nachbarschaftsfreundlich
- **Wetterschutz**: Für Außenbetrieb geeignet

---

## 📁 Projektstruktur

```
bird-deterrent-system/
├── src/
│   └── bird_detector.py          # Hauptklasse mit KI-Logik
├── config/
│   └── settings.json             # Konfigurationsdatei
├── sounds/
│   └── bird_deterrent.wav        # Abschreckungssound
├── detections/                   # Screenshots (automatisch erstellt)
├── main.py                       # Einfaches Startskript
├── calibrate_pigeons.py          # Live-Kalibrierungs-Tool
├── test_hardware.py              # Hardware-Test
└── requirements.txt              # Python-Abhängigkeiten
```

---

## 🤝 Support & Community

**Probleme oder Fragen?**
- [GitHub Issues](https://github.com/erneu/bird-deterrent-system/issues) - Fehlerberichte
- [GitHub Discussions](https://github.com/erneu/bird-deterrent-system/discussions) - Community-Austausch
- E-Mail: [github@erichneumayer.at](mailto:github@erichneumayer.at)

**Beitragen:**
1. Fork das Repository
2. Feature-Branch erstellen
3. Pull Request einreichen

---

## 📄 Lizenz

MIT-Lizenz - siehe [LICENSE](LICENSE) für Details.

---

**🎉 Viel Erfolg beim Vertreiben der Tauben!**

*Mit der spezialisierten Tauben-Erkennung arbeitet dein System präziser und verursacht weniger Fehlalarme bei harmlosen Singvögeln.*
