# Sounds für das Bird Deterrent System

Platziere hier deine Abschreckungssounds.

## Empfohlene Datei
- **Dateiname:** `bird_deterrent.wav`
- **Format:** WAV, MP3 oder OGG
- **Länge:** 2-5 Sekunden
- **Lautstärke:** Hoch, aber nicht übertreibend

## Kostenlose Sound-Quellen

### Freesound.org
- [Hawk Scream](https://freesound.org/search/?q=hawk+scream)
- [Ultrasonic Sound](https://freesound.org/search/?q=ultrasonic)
- [Bird Scare](https://freesound.org/search/?q=bird+scare)

### Empfohlene Sound-Typen
1. **Raubvogelrufe** (Habicht, Falke, Adler)
2. **Ultraschall-ähnliche Töne** (15-20 kHz)
3. **Knallgeräusche** (Peitschenknall, Klatschen)
4. **Metallische Geräusche** (Topfdeckel, Glocken)

## Sound erstellen

Falls du eigene Sounds erstellen möchtest:

```python
# Einfacher Piepton mit Python
import numpy as np
import soundfile as sf

# 440 Hz Ton für 2 Sekunden
duration = 2.0
sample_rate = 44100
frequency = 440

t = np.linspace(0, duration, int(sample_rate * duration))
sound = np.sin(2 * np.pi * frequency * t)

sf.write('bird_deterrent.wav', sound, sample_rate)
```

## Test
Nach dem Hinzufügen einer Sound-Datei:
```bash
python test_hardware.py
```
