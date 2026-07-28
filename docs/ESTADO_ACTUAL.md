# Estado actual de RiftBeat

Actualizado: 2026-07-27 22:53 America/Santiago

## Objetivo general

Desarrollar RiftBeat como un juego arcade rítmico para Android en el que el
jugador sobrevive 45 segundos alternando entre dos dimensiones y saltando
obstáculos sincronizados a 120 BPM.

## Situación vigente

- Hito actual: jugabilidad del MVP implementada; exportación Android en curso.
- Progreso aproximado del MVP: 80 %.
- Última funcionalidad terminada: bucle jugable completo con salto, cambio de
  dimensión, ritmo, colisiones, vidas, puntuación, victoria y derrota.
- Funcionalidad en desarrollo: generación y validación del primer APK.
- Estado de compilación: importación Godot 4.7.1 aprobada; APK pendiente.
- Estado de las pruebas: prueba headless y capturas renderizadas aprobadas.
- Último commit válido: pendiente de crear para la jugabilidad de la sesión 002.
- Rama actual: `main`.

## Entorno comprobado

- GitHub CLI 2.96.0: disponible.
- Cuenta GitHub activa: `7yrak`.
- Acceso a `7yrak/RiftBeat`: `ADMIN`.
- Java 21.0.11 LTS: disponible.
- Godot 4.7.1: instalado y verificado.
- Android Platform Tools 37.0.0: instalado.
- Android Build Tools 35.0.1: instalado.
- Android Platform 35: instalada.

## Bloqueos

- Ningún bloqueo técnico conocido para generar el primer APK.

## Problemas conocidos

- La licencia del proyecto está pendiente.
- El APK de prueba usará la firma debug de Godot; aún no es una compilación para
  Google Play.
- Falta una validación manual en un dispositivo Android físico.

## Próxima tarea exacta

Instalar las plantillas oficiales de Godot 4.7.1, ejecutar
`tools/export_android.ps1` y validar que el APK resultante tenga firma, metadatos
y checksum correctos.

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
