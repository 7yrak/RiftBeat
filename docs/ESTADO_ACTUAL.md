# Estado actual de RiftBeat

Actualizado: 2026-07-27 23:42 America/Santiago

## Objetivo general

Desarrollar RiftBeat como un juego arcade rítmico para Android en el que el
jugador sobrevive 45 segundos alternando entre dos dimensiones y saltando
obstáculos sincronizados a 120 BPM.

## Situación vigente

- Hito actual: versión Android `0.2.0` con sistema modular disponible para
  pruebas.
- Progreso aproximado del MVP ampliado: 84 %; falta validación física de los
  prototipos antes de crear etapas.
- Última funcionalidad terminada: catálogo modular de 12 piezas y prototipos de
  prensa rítmica, gravedad ligera y bloque destructible con Rift Pulse.
- Funcionalidad en desarrollo: ninguna; el siguiente paso es prueba física.
- Estado de compilación: APK `0.2.0` generado y validado en
  `release/RiftBeat-latest.apk`.
- Estado de las pruebas: catálogo, combinaciones, prototipos, regresiones, QA
  visual, exportación, firma, alineación, metadatos y checksum aprobados.
- Último commit fuente validado: `chore: track obstacle resource UIDs`.
- Commit fuente del APK vigente: `b05e82053143ef28cd4a81b1429a7766bcbf27c1`.
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
- El usuario completó más de tres partidas de `0.1.1` y confirmó que el concepto
  tiene potencial; falta validar los prototipos de `0.2.0`.
- `aapt2` informa una referencia opcional de icono temático del template
  precompilado; el APK, los iconos normales y adaptativos, la firma y la
  alineación son válidos.

## Próxima tarea exacta

Instalar `release/RiftBeat-latest.apk`, probar tres partidas en Android y
responder las cinco preguntas de `docs/OBSTACULOS.md`. No crear más etapas antes
de registrar ese resultado.

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
