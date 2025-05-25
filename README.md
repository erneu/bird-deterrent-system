ls /dev/video*

# Windows: Verschiedene camera_id Werte testen (0, 1, 2...)
```

### YOLO-Modell lädt nicht
```bash
# Internet-Verbindung prüfen - beim ersten Start wird das Modell heruntergeladen
ping google.com

# Cache löschen (bei Problemen)
rm -rf ~/.cache/torch/hub/ultralytics_yolov5_master/
```

### Audio funktioniert nicht
```bash
# Linux: Audio-System prüfen
aplay -l

# Pygame Audio-Treiber testen
python -c "import pygame; pygame.mixer.init(); print('Audio OK')"
```

### Performance-Probleme
- Kleineres YOLO-Modell verwenden (`yolov5n` statt `yolov5s`)
- Auflösung reduzieren (320x240 für sehr schwache Hardware)
- `confidence_threshold` erhöhen (weniger False Positives)
- Pause zwischen Frames vergrößern

## 📊 Monitoring & Logs

### Log-Datei überwachen
```bash
# Live-Logs anzeigen
tail -f bird_detector.log

# Erkennungen zählen
grep "Vogel erkannt" bird_detector.log | wc -l
```

### Erkennungsstatistiken
Das System erstellt automatisch:
- **Log-Einträge** für jede Erkennung
- **Screenshots** bei Erkennungen (optional)
- **Zeitstempel** aller Aktivitäten

## 🔄 Automatischer Start

### Linux Systemd Service
```bash
# Service-Datei erstellen
sudo nano /etc/systemd/system/bird-deterrent.service
```

```ini
[Unit]
Description=Bird Deterrent System
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/bird-deterrent-system
ExecStart=/usr/bin/python3 /home/pi/bird-deterrent-system/main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# Service aktivieren
sudo systemctl enable bird-deterrent.service
sudo systemctl start bird-deterrent.service

# Status prüfen
sudo systemctl status bird-deterrent.service
```

### Windows Autostart
1. `Win + R` → `shell:startup`
2. Batch-Datei erstellen (`start_bird_detector.bat`):
```batch
@echo off
cd /d "C:\Users\erich.neumayer\gitlab\bird-deterrent-system"
python main.py
pause
```

## 🎯 Erweiterte Features

### Web-Interface (geplant)
```python
# Einfaches Status-Dashboard
from flask import Flask, render_template
app = Flask(__name__)

@app.route('/')
def dashboard():
    return render_template('dashboard.html')
```

### Mobile Benachrichtigungen (geplant)
- Push-Notifications bei Erkennungen
- SMS/E-Mail-Alerts
- Telegram Bot Integration

### Mehrere Kameras (geplant)
- Multi-Kamera-Unterstützung
- Zoneneinteilung der Terrasse
- Koordinierte Abschreckung

## 🤝 Beitragen

1. Fork des Repositories
2. Feature-Branch erstellen (`git checkout -b feature/neue-funktion`)
3. Änderungen committen (`git commit -am 'Neue Funktion hinzugefügt'`)
4. Branch pushen (`git push origin feature/neue-funktion`)
5. Pull Request erstellen

## 📄 Lizenz

Dieses Projekt steht unter der MIT-Lizenz. Siehe `LICENSE` Datei für Details.

## 🆘 Support

**Häufige Probleme:**
- [GitHub Issues](https://github.com/username/bird-deterrent-system/issues)
- [Diskussionen](https://github.com/username/bird-deterrent-system/discussions)

**Kontakt:**
- E-Mail: erich.neumayer@example.com
- GitHub: [@erich-neumayer](https://github.com/erich-neumayer)

## 🙏 Danksagungen

- **Ultralytics** für YOLOv5
- **OpenCV** Community
- **PyGame** Entwickler
- Alle Beta-Tester und Contributor

---

**⚠️ Wichtige Hinweise:**
- Stelle sicher, dass die Kamera einen guten Blick auf die Terrasse hat
- Teste verschiedene Sounds für optimale Wirkung
- Berücksichtige Nachbarn bei der Lautstärke
- Das System erkennt auch andere Tiere - konfiguriere entsprechend

**🎉 Viel Erfolg beim Vertreiben der Vögel!**
        "max_aspect_ratio": 2.0
    },
    "detection_cooldown": 5,
    "deterrent_sound": "sounds/bird_deterrent.wav",
    "active_hours": {
        "start": 6,
        "end": 22
    },
    "log_level": "INFO",
    "show_preview": false
}
```

### 🐦 Tauben-Parameter erklärt

- **`pigeon_only_mode`**: `true` = nur Tauben, `false` = alle Vögel
- **`pigeon_confidence_threshold`**: Erkennungsschwelle speziell für Tauben (0.0-1.0)
- **`size_filter`**: Filtert nach typischen Taubengrößen
  - `min_relative_size`: Minimale Größe (0.5% des Bildes)
  - `max_relative_size`: Maximale Größe (20% des Bildes)
  - `min_aspect_ratio`: Mindest-Seitenverhältnis (0.5 = nicht zu dünn)
  - `max_aspect_ratio`: Maximal-Seitenverhältnis (2.0 = nicht zu lang)

### 🎯 Optimierung für verschiedene Szenarien

**Nahbereich (2-5m Entfernung):**
```json
{
    "size_filter": {
        "min_relative_size": 0.05,
        "max_relative_size": 0.25
    },
    "pigeon_confidence_threshold": 0.3
}
```

**Fernbereich (5-15m Entfernung):**
```json
{
    "size_filter": {
        "min_relative_size": 0.005,
        "max_relative_size": 0.05
    },
    "pigeon_confidence_threshold": 0.6
}
```

**Gemischter Bereich (flexibel):**
```json
{
    "size_filter": {
        "min_relative_size": 0.01,
        "max_relative_size": 0.15
    },
    "pigeon_confidence_threshold": 0.4
}
```

## 🔧 Tauben-Kalibrierung

Das System enthält ein spezielles Kalibrierungs-Tool für optimale Taubenerkennung:

```bash
python calibrate_pigeons.py
```

**Kalibrierungs-Features:**
- **Live-Preview** mit eingezeichneten Erkennungen
- **Interaktive Anpassung** der Confidence-Schwelle
- **Tauben-Modus umschalten** (nur Tauben vs. alle Vögel)
- **Echtzeit-Feedback** über Erkennungsqualität
- **Automatisches Speichern** der optimalen Einstellungen

**Steuerung während der Kalibrierung:**
- `+`/`-`: Confidence-Threshold anpassen
- `p`: Tauben-Modus umschalten
- `s`: Aktuelle Einstellungen speichern
- `q`: Kalibrierung beenden

## 📊 Tauben-Erkennungslogik

Das System verwendet mehrere Heuristiken zur Tauben-Identifikation:

### 1. Größenfilterung
- **Relative Bildgröße**: Tauben sind typischerweise 0.5-20% des Bildes
- **Seitenverhältnis**: Tauben sind eher kompakt (0.5-2.0 Verhältnis)

### 2. Verhaltensbasierte Erkennung
- **Bodennähe**: Bonus für Vögel im unteren Bildbereich (Tauben landen oft)
- **Typische Größe**: Extra-Confidence für mittelgroße Vögel

### 3. Confidence-Scoring
```python
final_confidence = base_confidence + bonuses
- Basis: YOLOv5 Vogel-Confidence
- Bonus: +0.1 für Bodennähe
- Bonus: +0.1 für typische Taubengröße
```

## 🎵 Tauben-spezifische Abschreckung

**Besonders effektive Sounds gegen Tauben:**

1. **Raubvogelrufe** (Empfehlung: Habicht oder Wanderfalke)
   - Tauben haben natürliche Angst vor Raubvögeln
   - Kurze, scharfe Rufe (2-3 Sekunden)

2. **Ultraschall-Töne** (18-22 kHz)
   - Für Menschen kaum hörbar
   - Störend für Tauben

3. **Metallische Klänge**
   - Schnelle Klappergeräusche
   - Topfdeckel oder Windspiele

**Sound-Tipp**: Wechsle Sounds regelmäßig, da sich Tauben an wiederkehrende Geräusche gewöhnen können.

## 🔍 Problembehandlung - Tauben-Edition

### Tauben werden nicht erkannt
```bash
# 1. Kalibrierung durchführen
python calibrate_pigeons.py

# 2. Tauben-Modus aktivieren
# In config/settings.json: "pigeon_only_mode": true

# 3. Confidence-Threshold senken
# In config/settings.json: "pigeon_confidence_threshold": 0.3
```

### Zu viele Fehlerkennungen
```bash
# 1. Confidence-Threshold erhöhen
# "pigeon_confidence_threshold": 0.6

# 2. Größenfilter verschärfen
# "min_relative_size": 0.02  (größer)
# "max_relative_size": 0.1   (kleiner)
```

### Kleine Tauben werden übersehen
```bash
# Mindestgröße reduzieren
# "min_relative_size": 0.005
```

### Große Tauben werden übersehen
```bash
# Maximalgröße erhöhen
# "max_relative_size": 0.3
```

## 📈 Monitoring & Statistiken

### Tauben-spezifische Logs
```bash
# Erkannte Tauben zählen
grep "Taube erkannt" bird_detector.log | wc -l

# Heutige Tauben-Aktivität
grep "$(date +%Y-%m-%d)" bird_detector.log | grep "Taube erkannt"

# Tauben-Erkennungsrate
grep -E "(Taube erkannt|Nicht als Taube)" bird_detector.log
```

### Performance-Analyse
```bash
# Größenverteilung der Erkennungen
grep "Typische Taubengröße" bird_detector.log

# Confidence-Verteilung
grep "Confidence:" bird_detector.log
```

## 🏠 Spezielle Installationstipps für Tauben

### Kamera-Positionierung
- **Höhe**: 2-3 Meter über dem Boden
- **Winkel**: Leicht nach unten geneigt (Tauben landen oft am Boden)
- **Sichtfeld**: Gesamte Terrasse erfassen
- **Schutz**: Wetterfest montieren

### Lautsprecher-Platzierung
- **Position**: Hoch und zentral
- **Richtung**: Zur Terrasse gerichtet
- **Lautstärke**: Hörbar, aber nachbarschaftsfreundlich
- **Wetterschutz**: Für Außenbetrieb geeignet

## 🚀 Erweiterte Tauben-Features

### Geplante Funktionen
- **Tauben-Schwarm-Erkennung**: Spezielle Behandlung von Taubengruppen
- **Lernende KI**: Anpassung an lokale Taubenpopulation
- **Tauben-Tracking**: Verfolgung einzelner Tauben über mehrere Frames
- **Tageszeit-Anpassung**: Verschiedene Empfindlichkeiten je nach Uhrzeit

### Community-Beiträge
- **Tauben-Soundbank**: Sammlung erprobter Abschreckungssounds
- **Kalibrierungs-Presets**: Optimierte Einstellungen für verschiedene Umgebungen
- **Erfolgsstatistiken**: Berichte über Abschreckungseffizienz

## 📄 Lizenz & Support

**Lizenz**: MIT-Lizenz - siehe `LICENSE` Datei

**Support & Community**:
- GitHub Issues für Problembericht
- Diskussionen für Tauben-spezifische Tipps
- Wiki für Kalibrierungs-Anleitungen

---

**🎉 Erfolgreich Tauben vertreiben!**

Mit der spezialisierten Tauben-Erkennung sollte dein System deutlich präziser arbeiten und weniger Fehlalarme bei anderen Vögeln auslösen.
