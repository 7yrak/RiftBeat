# Estado actual de RiftBeat

Actualizado: 2026-07-27 23:11 America/Santiago

## Objetivo general

Desarrollar RiftBeat como un juego arcade rítmico para Android en el que el
jugador sobrevive 45 segundos alternando entre dos dimensiones y saltando
obstáculos sincronizados a 120 BPM.

## Situación vigente

- Hito actual: versión Android `0.1.1` disponible para pruebas.
- Progreso aproximado del MVP: 97 %; falta validación física y calibración.
- Última funcionalidad terminada: salto característico **Rift Roll**, con cinco
  cuartos de giro, dirección por dimensión, estela, squash y onda de aterrizaje.
- Funcionalidad en desarrollo: ninguna; el siguiente paso es prueba física.
- Estado de compilación: APK `0.1.1` generado y validado en
  `release/RiftBeat-latest.apk`.
- Estado de las pruebas: automatización, QA visual, orientación, firma,
  alineación, metadatos, paquete y checksum aprobados; prueba física pendiente.
- Último commit fuente validado: `feat: add signature Rift Roll jump`.
- Commit fuente del APK vigente: `4751e9a88f35dcf176419b0880caca792d2e083e`.
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
- Falta una validación manual del Rift Roll y la rotación horizontal automática
  en un dispositivo Android físico.
- `aapt2` informa una referencia opcional de icono temático del template
  precompilado; el APK, los iconos normales y adaptativos, la firma y la
  alineación son válidos.

## Próxima tarea exacta

Instalar `release/RiftBeat-latest.apk` en un teléfono ARM64, rotar el dispositivo
en ambos sentidos horizontales y completar al menos tres partidas, registrando
sensación del Rift Roll, respuesta táctil, audio y rendimiento.

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
