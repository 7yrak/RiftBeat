[CmdletBinding()]
param(
    [string]$GodotPath = ""
)

$ErrorActionPreference = "Stop"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$releaseDirectory = Join-Path $projectRoot "release"
$apkPath = Join-Path $releaseDirectory "RiftBeat-latest.apk"
$checksumPath = "$apkPath.sha256"

function Resolve-GodotConsole {
    param([string]$RequestedPath)

    if (-not [string]::IsNullOrWhiteSpace($RequestedPath)) {
        if (-not (Test-Path -LiteralPath $RequestedPath -PathType Leaf)) {
            throw "No existe el ejecutable Godot indicado: $RequestedPath"
        }
        return (Resolve-Path -LiteralPath $RequestedPath).Path
    }

    $command = Get-Command "godot_console" -ErrorAction SilentlyContinue
    if ($null -ne $command) {
        return $command.Source
    }

    $wingetRoot = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"
    $candidate = Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue `
        -Path $wingetRoot -Filter "Godot*_console.exe" |
        Sort-Object FullName -Descending |
        Select-Object -First 1
    if ($null -ne $candidate) {
        return $candidate.FullName
    }

    throw "No se encontró Godot. Instala Godot 4.7.1 o indica -GodotPath."
}

$godot = Resolve-GodotConsole -RequestedPath $GodotPath
New-Item -ItemType Directory -Force -Path $releaseDirectory | Out-Null

Write-Host "Ejecutando pruebas headless..."
& $godot --headless --path $projectRoot --script res://tests/obstacle_system_test.gd
if ($LASTEXITCODE -ne 0) {
    throw "Las pruebas del sistema de obstáculos fallaron; no se generó un APK."
}

& $godot --headless --path $projectRoot --script res://tests/smoke_test.gd
if ($LASTEXITCODE -ne 0) {
    throw "Las pruebas fallaron; no se generó un APK."
}

Write-Host "Exportando APK Android..."
& $godot --headless --path $projectRoot --export-debug "Android" $apkPath
if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $apkPath)) {
    throw "La exportación Android falló."
}

$checksum = Get-FileHash -Algorithm SHA256 -LiteralPath $apkPath
"$($checksum.Hash.ToLowerInvariant())  RiftBeat-latest.apk" |
    Set-Content -Encoding ASCII -LiteralPath $checksumPath

Write-Host "APK: $apkPath"
Write-Host "SHA-256: $($checksum.Hash.ToLowerInvariant())"
