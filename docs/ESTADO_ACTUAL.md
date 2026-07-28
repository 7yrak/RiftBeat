# Estado actual de RiftBeat

Actualizado: 2026-07-27 22:27 America/Santiago

## Objetivo general

Desarrollar RiftBeat como un juego en Godot con destino Android. El concepto
jugable, las mecánicas principales y los criterios de finalización todavía deben
ser confirmados antes de fijar el alcance del MVP.

## Situación vigente

- Hito actual: repositorio y protocolo de continuidad inicializados.
- Progreso aproximado del MVP: 0 %, pendiente de definir el denominador.
- Última funcionalidad terminada: infraestructura documental y de control de
  versiones.
- Funcionalidad en desarrollo: ninguna; el siguiente trabajo es definir el MVP.
- Estado de compilación: no disponible; todavía no existe `project.godot`.
- Estado de las pruebas: comprobaciones de repositorio aprobadas; pruebas del
  juego no aplican todavía.
- Último commit válido: `docs: update project log` (cierre documental de la
  sesión 001).
- Rama actual: `main`.

## Entorno comprobado

- GitHub CLI 2.96.0: disponible.
- Cuenta GitHub activa: `7yrak`.
- Acceso a `7yrak/RiftBeat`: `ADMIN`.
- Java 21.0.11 LTS: disponible.
- Godot: no disponible en `PATH`.
- Gradle: no disponible en `PATH`.

## Bloqueos

- Falta una definición explícita del concepto y alcance del MVP.
- Falta elegir e instalar la versión objetivo de Godot.

## Problemas conocidos

- No hay proyecto ejecutable, escenas, scripts ni pruebas automatizadas.
- La licencia del proyecto está pendiente.
- No se puede validar todavía una exportación Android.

## Próxima tarea exacta

Documentar el MVP de RiftBeat —bucle jugable, controles, condición de éxito o
fallo, plataforma mínima y criterio de terminado— y escoger la versión de Godot.
Después, crear e importar un proyecto mínimo y verificar su arranque headless.

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
