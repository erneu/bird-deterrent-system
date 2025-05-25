# 🛠️ Installation Troubleshooting

## Problem: PyTorch Version Conflicts

Falls du den Fehler "torch 2.0.1 keine version satisfied" erhältst, verwende eine der folgenden Lösungen:

### 🚀 Lösung 1: Verbesserte Setup-Datei (Empfohlen)
```cmd
setup_fixed.bat
```

### 🚀 Lösung 2: Manuelle Installation
```cmd
# 1. PyTorch CPU-Version installieren
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

# 2. Andere Pakete installieren
pip install opencv-python ultralytics pygame numpy pandas
```

### 🚀 Lösung 3: Leichte Installation
```cmd
pip install -r requirements-light.txt
```

### 🚀 Lösung 4: Neueste Versionen (automatisch)
```cmd
pip install torch torchvision opencv-python ultralytics pygame numpy pandas --upgrade
```

## Häufige Probleme

### "No module named 'torch'"
```cmd
# PyTorch neu installieren
pip uninstall torch torchvision
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
```

### "CUDA not available" Warnung
Das ist normal! Wir verwenden die CPU-Version von PyTorch. Einfach ignorieren.

### Sehr lange Download-Zeiten
```cmd
# Verwende die CPU-Version (kleinere Dateigröße)
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
```

### Installation schlägt komplett fehl
```cmd
# Installiere Pakete einzeln
pip install opencv-python
pip install torch --index-url https://download.pytorch.org/whl/cpu  
pip install ultralytics
pip install pygame
```

## Erfolgstest

Nach der Installation teste mit:
```cmd
python -c "import torch; import cv2; import ultralytics; print('✅ Installation erfolgreich!')"
```

## System-spezifische Hinweise

### Windows
- Verwende `setup_fixed.bat` statt `setup.bat`
- Falls Permissions-Fehler: Kommandozeile als Administrator ausführen

### Raspberry Pi
```bash
# Spezielle ARM-Versionen
pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/cpu
```

### Linux
```bash
# System-Pakete installieren (Ubuntu/Debian)
sudo apt update
sudo apt install python3-pip python3-opencv portaudio19-dev
pip install -r requirements-light.txt
```
