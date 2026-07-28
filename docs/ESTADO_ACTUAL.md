# Estado actual de RiftBeat

Actualizado: 2026-07-27 23:38 America/Santiago

## Objetivo general

Desarrollar RiftBeat como un juego arcade rítmico para Android en el que el
jugador sobrevive 45 segundos alternando entre dos dimensiones y saltando
obstáculos sincronizados a 120 BPM.

## Situación vigente

- Hito actual: sistema modular y prototipos de `0.2.0` implementados; APK
  pendiente de regeneración.
- Progreso aproximado del MVP ampliado: 82 %; el alcance creció para incluir
  poderes y familias de obstáculos.
- Última funcionalidad terminada: catálogo modular de 12 piezas y prototipos de
  prensa rítmica, gravedad ligera y bloque destructible con Rift Pulse.
- Funcionalidad en desarrollo: publicación del APK Android `0.2.0`.
- Estado de compilación: la fuente pasa pruebas funcionales y QA visual; el APK
  estable todavía corresponde a `0.1.1`.
- Estado de las pruebas: catálogo, combinación de propiedades, prensa, gravedad,
  destrucción, cargas, juego previo y capturas aprobados; exportación pendiente.
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
- El usuario completó más de tres partidas de `0.1.1` y confirmó que el concepto
  tiene potencial; falta validar los prototipos de `0.2.0`.
- `aapt2` informa una referencia opcional de icono temático del template
  precompilado; el APK, los iconos normales y adaptativos, la firma y la
  alineación son válidos.

## Próxima tarea exacta

Generar y validar `release/RiftBeat-latest.apk` como versión `0.2.0`. Después,
probar tres partidas en Android y responder las cinco preguntas definidas en
`docs/OBSTACULOS.md` antes de crear más etapas.

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
