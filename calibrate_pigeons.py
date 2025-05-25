#!/usr/bin/env python3
"""
Spezielle Kalibrierung für Taubenerkennung
"""

import cv2
import sys
import json
from pathlib import Path

# Füge src-Ordner zum Python-Pfad hinzu
sys.path.insert(0, str(Path(__file__).parent / "src"))

from bird_detector import BirdDetector

def calibrate_pigeon_detection():
    """Interaktive Kalibrierung der Taubenerkennung"""
    print("🐦 Tauben-Erkennungs-Kalibrierung")
    print("=" * 40)
    
    # Lade aktuelle Konfiguration
    config_path = "config/settings.json"
    detector = BirdDetector(config_path)
    
    print("Drücke 'q' zum Beenden")
    print("Drücke 's' um aktuelle Einstellungen zu speichern")
    print("Drücke 'p' um Tauben-Modus umzuschalten")
    print("Drücke '+'/'-' um Confidence-Threshold anzupassen")
    
    # Zeige aktuelle Einstellungen
    def show_settings():
        pigeon_mode = detector.config.get('pigeon_only_mode', True)
        confidence = detector.config.get('pigeon_confidence_threshold', 0.5)
        print(f"\nAktuelle Einstellungen:")
        print(f"  Tauben-Modus: {'AN' if pigeon_mode else 'AUS'}")
        print(f"  Confidence-Threshold: {confidence:.2f}")
        print(f"  Größenfilter: {detector.config.get('size_filter', {})}")
    
    show_settings()
    
    # Live-Kalibrierung
    try:
        while True:
            ret, frame = detector.camera.read()
            if not ret:
                print("Kamera-Fehler!")
                break
            
            # Vogelerkennung durchführen
            bird_detected, detections = detector.detect_birds(frame)
            
            # Zeichne Erkennungen ein
            display_frame = frame.copy()
            for detection in detections:
                x1, y1, x2, y2 = int(detection['xmin']), int(detection['ymin']), int(detection['xmax']), int(detection['ymax'])
                confidence = detection['confidence']
                
                # Grüner Rahmen für erkannte Tauben
                cv2.rectangle(display_frame, (x1, y1), (x2, y2), (0, 255, 0), 2)
                cv2.putText(display_frame, f"Taube: {confidence:.2f}", 
                           (x1, y1-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
            
            # Status-Text
            status_color = (0, 255, 0) if bird_detected else (0, 0, 255)
            status_text = f"Tauben erkannt: {len(detections)}" if bird_detected else "Keine Tauben"
            cv2.putText(display_frame, status_text, (10, 30), 
                       cv2.FONT_HERSHEY_SIMPLEX, 1, status_color, 2)
            
            # Einstellungen anzeigen
            mode_text = "Modus: Nur Tauben" if detector.config.get('pigeon_only_mode', True) else "Modus: Alle Vögel"
            cv2.putText(display_frame, mode_text, (10, 60), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2)
            
            confidence_text = f"Threshold: {detector.config.get('pigeon_confidence_threshold', 0.5):.2f}"
            cv2.putText(display_frame, confidence_text, (10, 85), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2)
            
            cv2.imshow('Tauben-Kalibrierung', display_frame)
            
            # Tastatureingaben verarbeiten
            key = cv2.waitKey(1) & 0xFF
            
            if key == ord('q'):
                break
            elif key == ord('p'):
                # Tauben-Modus umschalten
                detector.config['pigeon_only_mode'] = not detector.config.get('pigeon_only_mode', True)
                show_settings()
            elif key == ord('+') or key == ord('='):
                # Confidence erhöhen
                current = detector.config.get('pigeon_confidence_threshold', 0.5)
                detector.config['pigeon_confidence_threshold'] = min(1.0, current + 0.05)
                show_settings()
            elif key == ord('-'):
                # Confidence verringern
                current = detector.config.get('pigeon_confidence_threshold', 0.5)
                detector.config['pigeon_confidence_threshold'] = max(0.1, current - 0.05)
                show_settings()
            elif key == ord('s'):
                # Einstellungen speichern
                save_config(detector.config, config_path)
                print("✅ Einstellungen gespeichert!")
    
    except KeyboardInterrupt:
        print("\nKalibrierung beendet")
    finally:
        detector.cleanup()

def save_config(config, config_path):
    """Speichert die Konfiguration"""
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=4)

def test_pigeon_sizes():
    """Testet verschiedene Taubengrößen anhand von Beispielbildern"""
    print("\n🔍 Taubengrößen-Analyse")
    print("=" * 30)
    
    detector = BirdDetector()
    
    # Beispiel-Größen für verschiedene Entfernungen
    sizes = [
        ("Sehr nah", 0.15, 0.25),      # 15-25% des Bildes
        ("Nah", 0.08, 0.15),           # 8-15% des Bildes
        ("Mittel", 0.03, 0.08),        # 3-8% des Bildes
        ("Fern", 0.01, 0.03),          # 1-3% des Bildes
        ("Sehr fern", 0.005, 0.01),    # 0.5-1% des Bildes
    ]
    
    print("Typische Taubengrößen nach Entfernung:")
    for distance, min_size, max_size in sizes:
        print(f"  {distance:10}: {min_size:.3f} - {max_size:.3f} (relative Bildgröße)")
    
    print(f"\nAktuelle Filtereinstellung: {detector.config.get('size_filter', {})}")

if __name__ == "__main__":
    print("Wähle einen Modus:")
    print("1. Live-Kalibrierung (empfohlen)")
    print("2. Größen-Analyse")
    
    choice = input("Eingabe (1 oder 2): ").strip()
    
    if choice == "1":
        calibrate_pigeon_detection()
    elif choice == "2":
        test_pigeon_sizes()
    else:
        print("Ungültige Eingabe")
