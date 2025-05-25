# Bird Deterrent System - Windows Setup mit VC++ Support
Write-Host "🐦 Bird Deterrent System - Windows Setup" -ForegroundColor Green
Write-Host "=" * 50

# Prüfe Python
Write-Host "`n1. 🐍 Prüfe Python-Installation..." -ForegroundColor Yellow
try {
    $pythonVersion = python --version 2>&1
    Write-Host "   ✅ $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Python nicht gefunden!" -ForegroundColor Red
    Write-Host "   Lade Python von https://python.org herunter" -ForegroundColor Yellow
    exit 1
}

# Prüfe Visual C++ Redistributable
Write-Host "`n2. 🔧 Prüfe Visual C++ Redistributable..." -ForegroundColor Yellow

# Teste ob VC++ benötigt wird
$vcppNeeded = $false
try {
    python -c "import cv2" 2>$null
    Write-Host "   ✅ Visual C++ ist verfügbar (OpenCV import erfolgreich)" -ForegroundColor Green
} catch {
    $vcppNeeded = $true
    Write-Host "   ❌ Visual C++ Redistributable fehlt!" -ForegroundColor Red
}

if ($vcppNeeded) {
    Write-Host "`n   🔽 Installiere Visual C++ Redistributable..." -ForegroundColor Yellow
    
    $vcUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
    $vcFile = "$env:TEMP\vc_redist.x64.exe"
    
    try {
        Write-Host "   📥 Lade herunter: $vcUrl" -ForegroundColor Gray
        Invoke-WebRequest -Uri $vcUrl -OutFile $vcFile -UseBasicParsing
        
        Write-Host "   🔧 Installiere Visual C++ (das kann einen Moment dauern)..." -ForegroundColor Gray
        Write-Host "   ⚠️  Falls UAC-Dialog erscheint, bitte bestätigen!" -ForegroundColor Yellow
        
        $process = Start-Process -FilePath $vcFile -ArgumentList "/install", "/quiet", "/norestart" -Wait -PassThru
        
        if ($process.ExitCode -eq 0) {
            Write-Host "   ✅ Visual C++ erfolgreich installiert" -ForegroundColor Green
        } else {
            Write-Host "   ⚠️  Installation möglicherweise bereits vorhanden (Exit Code: $($process.ExitCode))" -ForegroundColor Yellow
        }
        
        # Temporäre Datei löschen
        Remove-Item $vcFile -ErrorAction SilentlyContinue
        
    } catch {
        Write-Host "   ❌ Automatische Installation fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "   📌 Manuelle Installation erforderlich:" -ForegroundColor Yellow
        Write-Host "      1. Öffne: https://aka.ms/vs/17/release/vc_redist.x64.exe" -ForegroundColor Gray
        Write-Host "      2. Installiere die heruntergeladene Datei" -ForegroundColor Gray
        Write-Host "      3. Starte dieses Setup erneut" -ForegroundColor Gray
        
        $continue = Read-Host "`n   Visual C++ manuell installiert? (y/n)"
        if ($continue -ne "y") { exit 1 }
    }
}

# Python-Pakete installieren
Write-Host "`n3. 📦 Aktualisiere pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip | Out-Host

Write-Host "`n4. 🧠 Installiere PyTorch (CPU-Version)..." -ForegroundColor Yellow
try {
    python -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cpu | Out-Host
} catch {
    Write-Host "   Fallback: Standard PyTorch Installation..." -ForegroundColor Gray
    python -m pip install torch torchvision | Out-Host
}

Write-Host "`n5. 📹 Installiere Computer Vision..." -ForegroundColor Yellow
python -m pip install opencv-python ultralytics | Out-Host

Write-Host "`n6. 🔊 Installiere Audio und Basis-Pakete..." -ForegroundColor Yellow
python -m pip install pygame numpy pandas Pillow | Out-Host

# Ordner erstellen
Write-Host "`n7. 📁 Erstelle Projektordner..." -ForegroundColor Yellow
@("detections", "sounds") | ForEach-Object {
    if (-not (Test-Path $_)) {
        New-Item -ItemType Directory -Name $_ | Out-Null
        Write-Host "   ✅ Ordner '$_' erstellt" -ForegroundColor Green
    }
}

# Installation testen
Write-Host "`n8. 🧪 Teste Installation..." -ForegroundColor Yellow
Write-Host "   === Python-Pakete Test ===" -ForegroundColor Gray

$testResults = @()
$packages = @(
    @{Name="PyTorch"; ImportCmd="import torch; torch.__version__"},
    @{Name="OpenCV"; ImportCmd="import cv2; cv2.__version__"},
    @{Name="Ultralytics"; ImportCmd="import ultralytics; 'OK'"},
    @{Name="Pygame"; ImportCmd="import pygame; 'OK'"},
    @{Name="NumPy"; ImportCmd="import numpy; 'OK'"}
)

foreach ($pkg in $packages) {
    try {
        $result = python -c $pkg.ImportCmd 2>&1
        Write-Host "   ✅ $($pkg.Name): $result" -ForegroundColor Green
        $testResults += $true
    } catch {
        Write-Host "   ❌ $($pkg.Name): Import fehlgeschlagen" -ForegroundColor Red
        $testResults += $false
    }
}

if ($testResults -contains $false) {
    Write-Host "`n   ❌ Einige Pakete konnten nicht importiert werden!" -ForegroundColor Red
    Write-Host "   🔄 Versuche einen Neustart und führe das Setup erneut aus." -ForegroundColor Yellow
    Write-Host "   📋 Falls das Problem bestehen bleibt, siehe INSTALLATION_TROUBLESHOOTING.md" -ForegroundColor Gray
} else {
    Write-Host "`n   ✅ Alle Pakete erfolgreich installiert!" -ForegroundColor Green
    
    # Hardware-Test
    Write-Host "`n9. 🎥 Teste Hardware..." -ForegroundColor Yellow
    python test_hardware.py
}

Write-Host "`n🎉 Setup abgeschlossen!" -ForegroundColor Green
Write-Host "`n📋 Nächste Schritte:" -ForegroundColor Yellow
Write-Host "   1. Sound-Datei in sounds/bird_deterrent.wav ablegen" -ForegroundColor Gray
Write-Host "   2. Kamera anschließen" -ForegroundColor Gray
Write-Host "   3. Kalibrierung: python calibrate_pigeons.py" -ForegroundColor Gray
Write-Host "   4. System starten: python main.py" -ForegroundColor Gray

Write-Host "`nDrücke eine Taste zum Beenden..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
