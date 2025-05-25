@echo off
echo Bird Deterrent System - Windows Setup (mit VC++ Support)
echo =======================================================

echo 1. Pruefe Python-Installation...
python --version
if %ERRORLEVEL% neq 0 (
    echo FEHLER: Python ist nicht installiert oder nicht im PATH!
    echo Lade Python von https://python.org herunter
    pause
    exit /b 1
)

echo.
echo 2. Pruefe Visual C++ Redistributable...
echo Teste ob VC++ installiert ist...
python -c "import sys; print('Python läuft - VC++ Check...')" 2>nul
if %ERRORLEVEL% neq 0 (
    echo ⚠️ Visual C++ Runtime fehlt möglicherweise
)

echo Teste OpenCV Import (benötigt VC++)...
python -c "import cv2" 2>nul
if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ Microsoft Visual C++ Redistributable fehlt!
    echo.
    echo LÖSUNG 1 (Automatisch):
    echo Lade VC++ Redistributable herunter und installiere es automatisch...
    
    set "vc_url=https://aka.ms/vs/17/release/vc_redist.x64.exe"
    set "vc_file=%TEMP%\vc_redist.x64.exe"
    
    echo Lade herunter: !vc_url!
    powershell -Command "& {Invoke-WebRequest -Uri '%vc_url%' -OutFile '%vc_file%'}"
    
    if exist "%vc_file%" (
        echo Installiere Visual C++ Redistributable...
        echo Bitte bestätige die Installation in dem sich öffnenden Fenster.
        "%vc_file%" /install /quiet /norestart
        
        echo Warte auf Abschluss der Installation...
        timeout /t 10 /nobreak
        
        echo Installation abgeschlossen. Lösche temporäre Datei...
        del "%vc_file%" 2>nul
    ) else (
        echo Download fehlgeschlagen!
        goto :manual_vc_install
    )
    
    goto :continue_setup
) else (
    echo ✅ Visual C++ Redistributable ist bereits installiert
)

:manual_vc_install
echo.
echo LÖSUNG 2 (Manuell):
echo 1. Öffne: https://aka.ms/vs/17/release/vc_redist.x64.exe
echo 2. Lade die Datei herunter und installiere sie
echo 3. Starte danach dieses Setup erneut
echo.
choice /C YN /M "Visual C++ manuell installiert? Weiter mit Setup"
if errorlevel 2 exit /b 1

:continue_setup
echo.
echo 3. Aktualisiere pip...
python -m pip install --upgrade pip

echo.
echo 4. Installiere PyTorch (CPU-Version)...
python -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu

if %ERRORLEVEL% neq 0 (
    echo Fallback: Installiere PyTorch ohne spezielle URL...
    python -m pip install torch torchvision
)

echo.
echo 5. Installiere Computer Vision Pakete...
python -m pip install opencv-python ultralytics

echo.
echo 6. Installiere Audio und weitere Abhängigkeiten...
python -m pip install pygame numpy pandas Pillow

echo.
echo 7. Erstelle fehlende Ordner...
if not exist "detections" mkdir detections
if not exist "sounds" mkdir sounds

echo.
echo 8. Teste Installation (mit VC++ Support)...
python -c "print('=== Teste Python-Pakete ===');"
python -c "import torch; print('✅ PyTorch:', torch.__version__)"
python -c "import cv2; print('✅ OpenCV:', cv2.__version__)"
python -c "import ultralytics; print('✅ Ultralytics installiert')"
python -c "import pygame; print('✅ Pygame installiert')"
python -c "import numpy; print('✅ NumPy installiert')"
python -c "print('✅ Alle Pakete erfolgreich importiert!')"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ Import-Test fehlgeschlagen!
    echo Mögliche Ursachen:
    echo - Visual C++ Redistributable noch nicht vollständig installiert
    echo - Python-Paket-Installation fehlgeschlagen
    echo.
    echo Versuche einen Neustart des Computers und führe das Setup erneut aus.
    pause
    exit /b 1
)

echo.
echo 9. Teste Hardware...
python test_hardware.py

echo.
echo ✅ Setup erfolgreich abgeschlossen!
echo.
echo Naechste Schritte:
echo 1. Sound-Datei in sounds/bird_deterrent.wav ablegen
echo 2. Kamera anschliessen  
echo 3. Kalibrierung: python calibrate_pigeons.py
echo 4. System starten: python main.py
echo.
pause
