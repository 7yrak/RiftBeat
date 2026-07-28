# Estado actual de RiftBeat

Actualizado: 2026-07-27 22:59 America/Santiago

## Objetivo general

Desarrollar RiftBeat como un juego arcade rítmico para Android en el que el
jugador sobrevive 45 segundos alternando entre dos dimensiones y saltando
obstáculos sincronizados a 120 BPM.

## Situación vigente

- Hito actual: primera versión Android `0.1.0` disponible para pruebas.
- Progreso aproximado del MVP: 95 %; falta validación física y calibración.
- Última funcionalidad terminada: exportación Android ARM64 con iconos
  adaptativos, firma debug, checksum y metadatos de versión.
- Funcionalidad en desarrollo: ninguna; el siguiente paso es prueba física.
- Estado de compilación: APK generado y validado en
  `release/RiftBeat-latest.apk`.
- Estado de las pruebas: automatización, QA visual, firma, alineación, paquete y
  checksum aprobados; prueba física pendiente.
- Último commit válido: `chore: publish Android MVP 0.1.0`.
- Commit fuente del APK: `0904ca01b0736c042b75d1693158c47abc4dc5d1`.
- Rama actual: `main`.

## Entorno comprobado

- GitHub CLI 2.96.0: disponible.
- Cuenta GitHub activa: `7yrak`.
- Acceso a `7yrak/RiftBeat`: `ADMIN`.
- Java 21.0.11 LTS: disponible.
- Godot 4.7.1: instalado y verificado.
- Android Platform Tools 37.0.0: instalado.
- Android Build Tools 35.0.1 y 36.0.0: instalados.
- Android Platform 35 y 36: instaladas.

## Bloqueos

- No hay un dispositivo Android conectado por ADB para completar la prueba
  física.

## Problemas conocidos

- La licencia del proyecto está pendiente.
- El APK de prueba usará la firma debug de Godot; aún no es una compilación para
  Google Play.
- Falta una validación manual en un dispositivo Android físico.
- `aapt2` informa una referencia opcional de icono temático del template
  precompilado; el APK, los iconos normales y adaptativos, la firma y la
  alineación son válidos.

## Próxima tarea exacta

Instalar `release/RiftBeat-latest.apk` en un teléfono ARM64, completar al menos
tres partidas y registrar dificultad percibida, respuesta táctil, audio,
rendimiento y cualquier recorte visual.

## Comandos recomendados para continuar

```powershell
git pull --ff-only origin main
Get-Content -Raw README.md
Get-Content -Raw docs/ESTADO_ACTUAL.md
Get-Content -Tail 120 docs/BITACORA.md
Get-Content -Raw docs/DECISIONES.md
git status
git branch --show-current
git remote -v
git log --oneline -10
```

## Archivos que deben revisarse primero

1. `README.md`
2. `docs/ESTADO_ACTUAL.md`
3. `docs/BITACORA.md`
4. `docs/DECISIONES.md`
