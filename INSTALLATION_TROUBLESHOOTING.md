# 🛠️ Installation Troubleshooting

## ❌ Problem: Visual C++ Redistributable fehlt

**Fehlermeldung:**
```
Microsoft Visual C++ Redistributable is not installed.
It can be downloaded at https://aka.ms/vs/16/release/vc_redist.x64.exe
```

### 🚀 Lösung 1: Automatische Installation (Empfohlen)
```cmd
# Verwende das erweiterte Setup
setup_windows.ps1
```
oder
```cmd
setup_fixed.bat
```

### 🚀 Lösung 2: Manuelle Installation
1. **Download**: https://aka.ms/vs/17/release/vc_redist.x64.exe (neueste Version)
2. **Installieren**: Datei als Administrator ausführen
3. **Neustart**: Computer neustarten (empfohlen)
4. **Setup wiederholen**: `python test_hardware.py`

### 🚀 Lösung 3: Alternative VC++ Versionen
Falls die neueste Version nicht funktioniert:
- **Visual Studio 2019**: https://aka.ms/vs/16/release/vc_redist.x64.exe
- **Visual Studio 2015-2022**: https://learn.microsoft.com/cpp/windows/latest-supported-vc-redist

---

## ❌ Problem: PyTorch Version Conflicts

**Fehlermeldung:** "torch 2.0.1 keine version satisfied"

### 🚀 Lösung 1: CPU-optimierte Installation
```cmd
pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu
pip install opencv-python ultralytics pygame numpy pandas
```

### 🚀 Lösung 2: Neueste Versionen automatisch
```cmd
pip install torch torchvision opencv-python ultralytics pygame numpy pandas --upgrade
```

### 🚀 Lösung 3: Leichte Installation
```cmd
pip install -r requirements-light.txt
```

---

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
