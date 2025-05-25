#!/bin/bash
echo "Bird Deterrent System - Linux Setup"
echo "===================================="

echo "1. Prüfe Python-Installation..."
if ! command -v python3 &> /dev/null; then
    echo "FEHLER: Python3 ist nicht installiert!"
    echo "Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-pip"
    echo "Fedora: sudo dnf install python3 python3-pip"
    exit 1
fi

python3 --version

echo "2. Installiere System-Abhängigkeiten..."
if command -v apt &> /dev/null; then
    # Ubuntu/Debian
    sudo apt update
    sudo apt install -y python3-opencv python3-pygame portaudio19-dev
elif command -v dnf &> /dev/null; then
    # Fedora
    sudo dnf install -y python3-opencv python3-pygame portaudio-devel
fi

echo "3. Installiere Python-Pakete..."
pip3 install -r requirements.txt

echo "4. Erstelle fehlende Ordner..."
mkdir -p detections sounds

echo "5. Setze Berechtigungen..."
chmod +x main.py test_hardware.py

echo "6. Teste Hardware..."
python3 test_hardware.py

echo ""
echo "Setup abgeschlossen!"
echo ""
echo "Nächste Schritte:"
echo "1. Sound-Datei in sounds/bird_deterrent.wav ablegen"
echo "2. Kamera anschließen"
echo "3. System starten mit: python3 main.py"
echo ""
