@echo off
echo GitHub Upload Script - Bird Deterrent System
echo =============================================

echo 1. Wechsle ins Projektverzeichnis...
cd /d "C:\Users\erich.neumayer\gitlab\bird-deterrent-system"

echo 2. Prüfe Git-Status...
git status

echo 3. Stelle SSH-Verbindung zu GitHub her...
echo Teste SSH-Verbindung...
ssh -T -o "StrictHostKeyChecking=no" -i "C:\Users\erich.neumayer\.ssh\erichneumayer_id_rsa" git@github.com

echo 4. Push Repository zu GitHub...
echo Achtung: Falls das Repository noch nicht auf GitHub existiert,
echo erstelle es zuerst auf https://github.com/erneu
echo.
pause

echo Starte Upload...
git push -u origin main

if %ERRORLEVEL% == 0 (
    echo.
    echo ✅ Erfolgreich! Repository ist jetzt verfügbar unter:
    echo https://github.com/erneu/bird-deterrent-system
    echo.
) else (
    echo.
    echo ❌ Upload fehlgeschlagen!
    echo.
    echo Mögliche Lösungen:
    echo 1. Repository auf GitHub erstellen: https://github.com/new
    echo 2. SSH-Key zu GitHub hinzufügen
    echo 3. SSH-Agent starten: ssh-agent ^& ssh-add C:\Users\erich.neumayer\.ssh\erichneumayer_id_rsa
    echo.
)

pause
