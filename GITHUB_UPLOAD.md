# 🚀 GitHub Upload Anleitung

## Automatische Upload-Scripts

Das Projekt enthält zwei Upload-Scripts:

### Option 1: PowerShell (Empfohlen)
```powershell
.\upload_to_github.ps1
```

### Option 2: Batch-Datei
```cmd
upload_to_github.bat
```

## Manuelle Schritte (falls Scripts nicht funktionieren)

### 1. Repository auf GitHub erstellen
1. Besuche: https://github.com/new
2. Repository-Name: `bird-deterrent-system`
3. Beschreibung: `🐦 Intelligent bird deterrent system with AI-powered pigeon detection`
4. Wähle "Public" oder "Private"
5. **NICHT** "Initialize with README" ankreuzen
6. Klicke "Create Repository"

### 2. SSH-Key zu GitHub hinzufügen (falls noch nicht geschehen)
1. Öffne: https://github.com/settings/keys
2. Klicke "New SSH key"
3. Kopiere den Inhalt von: `C:\Users\erich.neumayer\.ssh\erichneumayer_id_rsa.pub`
4. Füge ihn ein und speichere

### 3. Upload durchführen
```bash
cd "C:\Users\erich.neumayer\gitlab\bird-deterrent-system"

# SSH-Agent starten
ssh-agent
ssh-add C:\Users\erich.neumayer\.ssh\erichneumayer_id_rsa

# GitHub-Verbindung testen
ssh -T git@github.com

# Repository hochladen
git push -u origin main
```

## Erwartetes Ergebnis

Nach erfolgreichem Upload ist das Repository verfügbar unter:
**https://github.com/erneu/bird-deterrent-system**

## Troubleshooting

### "Permission denied (publickey)"
- SSH-Key zu GitHub hinzufügen
- SSH-Agent neu starten

### "Repository not found"
- Repository auf GitHub erstellen
- Remote-URL prüfen: `git remote -v`

### "Connection timeout"
- Internet-Verbindung prüfen
- Firewall-Einstellungen überprüfen
