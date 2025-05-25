#!/usr/bin/env python3
"""
Einfaches Startskript für das Bird Deterrent System
"""

import sys
import os
from pathlib import Path

# Füge src-Ordner zum Python-Pfad hinzu
sys.path.insert(0, str(Path(__file__).parent / "src"))

from bird_detector import BirdDetector

def main():
    """Hauptfunktion"""
    print("🐦 Bird Deterrent System wird gestartet...")
    print("Drücke Ctrl+C zum Beenden")
    
    try:
        detector = BirdDetector()
        detector.run()
    except KeyboardInterrupt:
        print("\n👋 System wird beendet...")
    except Exception as e:
        print(f"❌ Fehler beim Start: {e}")
        print("Stelle sicher, dass alle Abhängigkeiten installiert sind:")
        print("pip install -r requirements.txt")

if __name__ == "__main__":
    main()
