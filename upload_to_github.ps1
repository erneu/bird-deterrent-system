# GitHub Upload Script - PowerShell Version
Write-Host "🚀 GitHub Upload Script - Bird Deterrent System" -ForegroundColor Green
Write-Host "=" * 50

# Wechsle ins Projektverzeichnis
Set-Location "C:\Users\erich.neumayer\gitlab\bird-deterrent-system"

Write-Host "📁 Projektverzeichnis: $(Get-Location)" -ForegroundColor Yellow

# Prüfe Git-Status
Write-Host "`n📋 Git-Status:" -ForegroundColor Yellow
git status --short

# SSH-Agent starten und Key hinzufügen
Write-Host "`n🔐 SSH-Konfiguration..." -ForegroundColor Yellow

# SSH-Agent starten (falls nicht aktiv)
$sshAgent = Get-Process ssh-agent -ErrorAction SilentlyContinue
if (-not $sshAgent) {
    Write-Host "Starte SSH-Agent..." -ForegroundColor Gray
    Start-Service ssh-agent -ErrorAction SilentlyContinue
}

# SSH-Key hinzufügen
$keyPath = "C:\Users\erich.neumayer\.ssh\erichneumayer_id_rsa"
if (Test-Path $keyPath) {
    Write-Host "Füge SSH-Key hinzu: $keyPath" -ForegroundColor Gray
    ssh-add $keyPath
} else {
    Write-Host "❌ SSH-Key nicht gefunden: $keyPath" -ForegroundColor Red
    exit 1
}

# GitHub-Verbindung testen
Write-Host "`n🌐 Teste GitHub-Verbindung..." -ForegroundColor Yellow
$sshTest = ssh -T git@github.com 2>&1
Write-Host "SSH-Test Ergebnis: $sshTest" -ForegroundColor Gray

# Repository-Erstellung prüfen
Write-Host "`n📦 Repository-Status:" -ForegroundColor Yellow
$remoteCheck = git ls-remote origin 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Repository existiert noch nicht auf GitHub!" -ForegroundColor Red
    Write-Host "Bitte erstelle das Repository zuerst:" -ForegroundColor Yellow
    Write-Host "https://github.com/new" -ForegroundColor Cyan
    Write-Host "Repository-Name: bird-deterrent-system" -ForegroundColor Cyan
    Write-Host "Beschreibung: 🐦 Intelligent bird deterrent system with AI-powered pigeon detection" -ForegroundColor Cyan
    
    $createRepo = Read-Host "`nRepository auf GitHub erstellt? (y/n)"
    if ($createRepo -ne "y") {
        Write-Host "Upload abgebrochen." -ForegroundColor Red
        exit 1
    }
}

# Upload durchführen
Write-Host "`n🚀 Starte Upload zu GitHub..." -ForegroundColor Green
Write-Host "Repository: https://github.com/erneu/bird-deterrent-system" -ForegroundColor Cyan

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n✅ Erfolgreich hochgeladen!" -ForegroundColor Green
    Write-Host "🌐 Repository verfügbar unter:" -ForegroundColor Yellow
    Write-Host "https://github.com/erneu/bird-deterrent-system" -ForegroundColor Cyan
    
    # Browser öffnen
    $openBrowser = Read-Host "`nRepository im Browser öffnen? (y/n)"
    if ($openBrowser -eq "y") {
        Start-Process "https://github.com/erneu/bird-deterrent-system"
    }
} else {
    Write-Host "`n❌ Upload fehlgeschlagen!" -ForegroundColor Red
    Write-Host "Überprüfe:" -ForegroundColor Yellow
    Write-Host "- SSH-Key in GitHub hinterlegt" -ForegroundColor Gray
    Write-Host "- Repository auf GitHub erstellt" -ForegroundColor Gray
    Write-Host "- Internet-Verbindung aktiv" -ForegroundColor Gray
}

Write-Host "`nDrücke eine Taste zum Beenden..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
