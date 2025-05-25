#!/usr/bin/env python3
"""
Bird Deterrent System - Hauptklasse für Vogelerkennung und Abschreckung
"""

import cv2
import torch
import pygame
import time
import logging
import json
from datetime import datetime
from pathlib import Path
from threading import Thread
import numpy as np


class BirdDetector:
    def __init__(self, config_path="config/settings.json"):
        """
        Initialisiert den Vogeldetektor
        
        Args:
            config_path (str): Pfad zur Konfigurationsdatei
        """
        self.config = self._load_config(config_path)
        self.setup_logging()
        
        # YOLO-Modell laden
        self.logger.info("Lade YOLO-Modell...")
        self.model = torch.hub.load('ultralytics/yolov5', self.config['model_size'])
        
        # Kamera initialisieren
        self.logger.info("Initialisiere Kamera...")
        self.camera = cv2.VideoCapture(self.config['camera_id'])
        self.camera.set(cv2.CAP_PROP_FRAME_WIDTH, self.config['frame_width'])
        self.camera.set(cv2.CAP_PROP_FRAME_HEIGHT, self.config['frame_height'])
        
        # Audio initialisieren
        pygame.mixer.init()
        
        # Status-Variablen
        self.last_detection_time = 0
        self.is_running = False
        
    def _load_config(self, config_path):
        """Lädt die Konfiguration aus JSON-Datei"""
        try:
            with open(config_path, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            self.logger.warning(f"Konfigurationsdatei {config_path} nicht gefunden. Verwende Standardwerte.")
            return self._get_default_config()
    
    def _get_default_config(self):
        """Standardkonfiguration"""
        return {
            "model_size": "yolov5s",
            "camera_id": 0,
            "frame_width": 640,
            "frame_height": 480,
            "confidence_threshold": 0.5,
            "pigeon_confidence_threshold": 0.4,
            "pigeon_only_mode": True,
            "size_filter": {
                "min_relative_size": 0.005,
                "max_relative_size": 0.2,
                "min_aspect_ratio": 0.5,
                "max_aspect_ratio": 2.0
            },
            "detection_cooldown": 5,
            "deterrent_sound": "sounds/bird_deterrent.wav",
            "active_hours": {"start": 6, "end": 22},
            "log_level": "INFO"
        }
    
    def setup_logging(self):
        """Richtet das Logging ein"""
        logging.basicConfig(
            level=getattr(logging, self.config['log_level']),
            format='%(asctime)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler('bird_detector.log'),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger(__name__)
    
    def is_active_time(self):
        """Prüft, ob das System zur aktuellen Zeit aktiv sein soll"""
        current_hour = datetime.now().hour
        start_hour = self.config['active_hours']['start']
        end_hour = self.config['active_hours']['end']
        return start_hour <= current_hour <= end_hour
    
    def detect_birds(self, frame):
        """
        Erkennt Vögel (speziell Tauben) im gegebenen Frame
        
        Args:
            frame: OpenCV-Frame
            
        Returns:
            tuple: (bird_detected: bool, detections: list)
        """
        results = self.model(frame)
        detections = results.pandas().xyxy[0]
        
        # Filtere nach Vögeln mit Mindest-Confidence
        birds = detections[
            (detections['name'] == 'bird') & 
            (detections['confidence'] >= self.config['confidence_threshold'])
        ]
        
        if len(birds) == 0:
            return False, []
        
        # Zusätzliche Tauben-spezifische Filterung
        pigeon_detections = []
        for _, detection in birds.iterrows():
            if self._is_likely_pigeon(detection, frame):
                pigeon_detections.append(detection.to_dict())
        
        return len(pigeon_detections) > 0, pigeon_detections
    
    def _is_likely_pigeon(self, detection, frame):
        """
        Zusätzliche Heuristiken zur Tauben-Identifikation
        
        Args:
            detection: Erkannte Vogel-Bounding-Box
            frame: Aktueller Frame
            
        Returns:
            bool: True wenn wahrscheinlich eine Taube
        """
        # Wenn pigeon_only_mode deaktiviert ist, akzeptiere alle Vögel
        if not self.config.get('pigeon_only_mode', True):
            return True
        
        # Bounding Box Koordinaten
        x1, y1, x2, y2 = int(detection['xmin']), int(detection['ymin']), int(detection['xmax']), int(detection['ymax'])
        
        # Größenfilter - Tauben sind mittelgroße Vögel
        box_width = x2 - x1
        box_height = y2 - y1
        box_area = box_width * box_height
        
        # Relative Größe zum Gesamtbild
        frame_area = frame.shape[0] * frame.shape[1]
        relative_size = box_area / frame_area
        
        # Konfigurierbare Größenfilter
        size_config = self.config.get('size_filter', {})
        min_size = size_config.get('min_relative_size', 0.005)
        max_size = size_config.get('max_relative_size', 0.2)
        
        if not (min_size < relative_size < max_size):
            self.logger.debug(f"Vogel zu klein/groß: {relative_size:.3f} (erlaubt: {min_size}-{max_size})")
            return False
        
        # Seitenverhältnis - Tauben sind eher rundlich/kompakt
        aspect_ratio = box_width / box_height if box_height > 0 else 0
        min_aspect = size_config.get('min_aspect_ratio', 0.5)
        max_aspect = size_config.get('max_aspect_ratio', 2.0)
        
        if not (min_aspect < aspect_ratio < max_aspect):
            self.logger.debug(f"Vogel hat ungünstiges Seitenverhältnis: {aspect_ratio:.2f}")
            return False
        
        # Confidence-Bonus für typische Tauben-Szenarien
        confidence_bonus = 0
        
        # Höhere Confidence für Vögel am Boden (Tauben landen oft)
        if (y2 / frame.shape[0]) > 0.7:  # Untere 30% des Bildes
            confidence_bonus += 0.1
            self.logger.debug("Bonus: Vogel am Boden")
        
        # Höhere Confidence für mittelgroße Vögel (typische Taubengröße)
        if 0.02 < relative_size < 0.08:
            confidence_bonus += 0.1
            self.logger.debug("Bonus: Typische Taubengröße")
        
        # Finale Confidence-Bewertung
        final_confidence = detection['confidence'] + confidence_bonus
        threshold = self.config.get('pigeon_confidence_threshold', 0.5)
        
        is_pigeon = final_confidence >= threshold
        
        if is_pigeon:
            self.logger.debug(f"Taube erkannt - Confidence: {final_confidence:.2f}, Größe: {relative_size:.3f}")
        else:
            self.logger.debug(f"Nicht als Taube klassifiziert - Confidence: {final_confidence:.2f} < {threshold}")
        
        return is_pigeon
    
    def play_deterrent_sound(self):
        """Spielt den Abschreckungssound ab"""
        try:
            sound_path = self.config['deterrent_sound']
            if Path(sound_path).exists():
                pygame.mixer.music.load(sound_path)
                pygame.mixer.music.play()
                self.logger.info("Abschreckungssound abgespielt")
            else:
                self.logger.warning(f"Sound-Datei {sound_path} nicht gefunden")
        except Exception as e:
            self.logger.error(f"Fehler beim Abspielen des Sounds: {e}")
    
    def process_detection(self, detections):
        """Verarbeitet eine Vogelerkennung"""
        current_time = time.time()
        
        # Cooldown prüfen
        if current_time - self.last_detection_time < self.config['detection_cooldown']:
            return
        
        pigeon_mode = self.config.get('pigeon_only_mode', True)
        bird_type = "Taube" if pigeon_mode else "Vogel"
        
        self.logger.info(f"{bird_type} erkannt! Anzahl: {len(detections)}")
        
        # Sound abspielen
        self.play_deterrent_sound()
        
        # Letzten Erkennungszeitpunkt speichern
        self.last_detection_time = current_time
        
        # Optional: Screenshot speichern
        self.save_detection_image()
    
    def save_detection_image(self):
        """Speichert ein Bild der aktuellen Erkennung"""
        ret, frame = self.camera.read()
        if ret:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"detections/bird_detection_{timestamp}.jpg"
            Path("detections").mkdir(exist_ok=True)
            cv2.imwrite(filename, frame)
            self.logger.info(f"Screenshot gespeichert: {filename}")
    
    def run(self):
        """Hauptschleife des Detektors"""
        self.logger.info("Bird Deterrent System gestartet")
        self.is_running = True
        
        try:
            while self.is_running:
                if not self.is_active_time():
                    time.sleep(60)  # 1 Minute warten wenn inaktiv
                    continue
                
                ret, frame = self.camera.read()
                if not ret:
                    self.logger.error("Fehler beim Lesen der Kamera")
                    time.sleep(1)
                    continue
                
                # Vogelerkennung durchführen
                bird_detected, detections = self.detect_birds(frame)
                
                if bird_detected:
                    self.process_detection(detections)
                
                # Optional: Live-Preview anzeigen (für Debugging)
                if self.config.get('show_preview', False):
                    cv2.imshow('Bird Detector', frame)
                    if cv2.waitKey(1) & 0xFF == ord('q'):
                        break
                
                time.sleep(0.1)  # Kurze Pause zwischen Frames
                
        except KeyboardInterrupt:
            self.logger.info("System durch Benutzer beendet")
        except Exception as e:
            self.logger.error(f"Unerwarteter Fehler: {e}")
        finally:
            self.cleanup()
    
    def stop(self):
        """Stoppt das System"""
        self.is_running = False
    
    def cleanup(self):
        """Räumt Ressourcen auf"""
        self.logger.info("Räume Ressourcen auf...")
        if self.camera:
            self.camera.release()
        cv2.destroyAllWindows()
        pygame.mixer.quit()
        self.logger.info("Bird Deterrent System beendet")


if __name__ == "__main__":
    detector = BirdDetector()
    detector.run()
