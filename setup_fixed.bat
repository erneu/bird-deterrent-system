@echo off
echo Bird Deterrent System - Windows Setup (Verbessert)
echo ====================================================

echo 1. Pruefe Python-Installation...
python --version
if %ERRORLEVEL% neq 0 (
    echo FEHLER: Python ist nicht installiert oder nicht im PATH!
    echo Lade Python von https://python.org herunter
    pause
    exit /b 1
)

echo.
echo 2. Aktualisiere pip...
python -m pip install --upgrade pip

echo.
echo 3. Installiere PyTorch (CPU-Version)...
python -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

if %ERRORLEVEL% neq 0 (
    echo Fallback: Installiere PyTorch ohne spezielle URL...
    python -m pip install torch torchvision
)

echo.
echo 4. Installiere Computer Vision Pakete...
python -m pip install opencv-python ultralytics

echo.
echo 5. Installiere Audio und weitere Abhängigkeiten...
python -m pip install pygame numpy pandas Pillow

if %ERRORLEVEL% neq 0 (
    echo FEHLER: Installation einiger Pakete fehlgeschlagen!
    echo Versuche alternative Installation...
    python -m pip install -r requirements.txt --no-deps
)

echo.
echo 6. Erstelle fehlende Ordner...
if not exist "detections" mkdir detections
if not exist "sounds" mkdir sounds

echo.
echo 7. Teste Installation...
python -c "import torch; import cv2; import ultralytics; print('✅ Alle Pakete erfolgreich importiert!')"

if %ERRORLEVEL% neq 0 (
    echo ⚠️ Import-Test fehlgeschlagen. Überprüfe die Installation.
) else (
    echo.
    echo 8. Teste Hardware...
    python test_hardware.py
)

echo.
echo Setup abgeschlossen!
echo.
echo Naechste Schritte:
echo 1. Sound-Datei in sounds/bird_deterrent.wav ablegen
echo 2. Kamera anschliessen  
echo 3. Kalibrierung: python calibrate_pigeons.py
echo 4. System starten: python main.py
echo.
pause
