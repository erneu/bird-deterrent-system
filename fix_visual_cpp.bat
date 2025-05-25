@echo off
echo Visual C++ Redistributable Quick Fix
echo ====================================

echo Diese Batch-Datei löst das Visual C++ Problem automatisch.

echo.
echo 1. Lade Visual C++ Redistributable herunter...
set "vc_url=https://aka.ms/vs/17/release/vc_redist.x64.exe"
set "vc_file=%TEMP%\vc_redist.x64.exe"

echo Download-URL: %vc_url%
echo Ziel: %vc_file%

powershell -Command "Invoke-WebRequest -Uri '%vc_url%' -OutFile '%vc_file%'"

if not exist "%vc_file%" (
    echo FEHLER: Download fehlgeschlagen!
    echo Bitte manuell herunterladen: %vc_url%
    pause
    exit /b 1
)

echo.
echo 2. Installiere Visual C++ Redistributable...
echo HINWEIS: UAC-Dialog wird erscheinen - bitte bestätigen!

"%vc_file%" /install /quiet /norestart

echo.
echo 3. Warte auf Abschluss...
timeout /t 15 /nobreak >nul

echo.
echo 4. Lösche temporäre Datei...
del "%vc_file%" 2>nul

echo.
echo 5. Teste Installation...
python -c "import cv2; print('✅ Visual C++ erfolgreich installiert - OpenCV funktioniert!')"

if %ERRORLEVEL% == 0 (
    echo.
    echo ✅ SUCCESS! Visual C++ ist jetzt installiert.
    echo Du kannst nun das normale Setup ausführen:
    echo    setup_windows.ps1
    echo oder
    echo    setup_fixed.bat
) else (
    echo.
    echo ❌ Test fehlgeschlagen. Mögliche Lösungen:
    echo 1. Computer neustarten und erneut versuchen
    echo 2. Manual installation: %vc_url%
    echo 3. Verschiedene VC++ Versionen probieren
)

echo.
pause
