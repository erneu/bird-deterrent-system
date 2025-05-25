@echo off
echo Bird Deterrent System - Windows Setup
echo =====================================

echo 1. Pruefe Python-Installation...
python --version
if %ERRORLEVEL% neq 0 (
    echo FEHLER: Python ist nicht installiert oder nicht im PATH!
    echo Lade Python von https://python.org herunter
    pause
    exit /b 1
)

echo 2. Installiere Python-Pakete...
pip install -r requirements.txt
if %ERRORLEVEL% neq 0 (
    echo FEHLER: Installation fehlgeschlagen!
    pause
    exit /b 1
)

echo 3. Erstelle fehlende Ordner...
if not exist "detections" mkdir detections
if not exist "sounds" mkdir sounds

echo 4. Teste Hardware...
python test_hardware.py

echo.
echo Setup abgeschlossen!
echo.
echo Naechste Schritte:
echo 1. Sound-Datei in sounds/bird_deterrent.wav ablegen
echo 2. Kamera anschliessen
echo 3. System starten mit: python main.py
echo.
pause
