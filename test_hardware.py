#!/usr/bin/env python3
"""
Test-Skript für Kamera und grundlegende Funktionen
"""

import cv2
import pygame
import sys
from pathlib import Path

def test_camera():
    """Testet die Kamera-Verbindung"""
    print("🎥 Teste Kamera...")
    
    for camera_id in range(3):  # Teste IDs 0, 1, 2
        cap = cv2.VideoCapture(camera_id)
        if cap.isOpened():
            ret, frame = cap.read()
            if ret:
                print(f"✅ Kamera {camera_id} funktioniert - Auflösung: {frame.shape[1]}x{frame.shape[0]}")
                cap.release()
                return camera_id
            cap.release()
        else:
            print(f"❌ Kamera {camera_id} nicht verfügbar")
    
    print("❌ Keine funktionsfähige Kamera gefunden!")
    return None

def test_audio():
    """Testet die Audio-Wiedergabe"""
    print("🔊 Teste Audio...")
    
    try:
        pygame.mixer.init()
        print("✅ Audio-System initialisiert")
        
        # Teste mit einem einfachen Beep-Sound
        sound_file = Path("sounds/bird_deterrent.wav")
        if sound_file.exists():
            pygame.mixer.music.load(str(sound_file))
            print("✅ Sound-Datei gefunden und geladen")
            
            print("🎵 Spiele Test-Sound ab...")
            pygame.mixer.music.play()
            input("Drücke Enter wenn du den Sound hörst...")
            
        else:
            print(f"⚠️  Sound-Datei nicht gefunden: {sound_file}")
            print("   Erstelle eine Beispiel-Sound-Datei oder lade eine herunter")
            
        pygame.mixer.quit()
        
    except Exception as e:
        print(f"❌ Audio-Fehler: {e}")

def test_yolo():
    """Testet das YOLO-Modell"""
    print("🤖 Teste YOLO-Modell...")
    
    try:
        import torch
        print("✅ PyTorch installiert")
        
        # Lade kleinstes Modell für Test
        model = torch.hub.load('ultralytics/yolov5', 'yolov5n')
        print("✅ YOLOv5 Modell geladen")
        
        # Teste mit Dummy-Bild
        import numpy as np
        dummy_image = np.random.randint(0, 255, (480, 640, 3), dtype=np.uint8)
        results = model(dummy_image)
        print("✅ Inferenz funktioniert")
        
        return True
        
    except Exception as e:
        print(f"❌ YOLO-Fehler: {e}")
        return False

def main():
    """Führt alle Tests durch"""
    print("🧪 Bird Deterrent System - Hardware Test")
    print("=" * 50)
    
    # Teste alle Komponenten
    camera_id = test_camera()
    print()
    
    test_audio()
    print()
    
    yolo_ok = test_yolo()
    print()
    
    # Zusammenfassung
    print("📋 Test-Zusammenfassung:")
    print("=" * 50)
    
    if camera_id is not None:
        print(f"✅ Kamera: ID {camera_id} funktioniert")
    else:
        print("❌ Kamera: Nicht funktionsfähig")
    
    print("✅ Audio: System verfügbar" if pygame.mixer.get_init() else "❌ Audio: Problem")
    print("✅ YOLO: Modell funktioniert" if yolo_ok else "❌ YOLO: Problem")
    
    if camera_id is not None and yolo_ok:
        print("\n🎉 Alle Tests bestanden! System ist bereit.")
        print("Starte das System mit: python main.py")
    else:
        print("\n⚠️  Einige Tests fehlgeschlagen. Prüfe die Installation.")

if __name__ == "__main__":
    main()
