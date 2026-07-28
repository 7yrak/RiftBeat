# RiftBeat

Juego arcade rítmico de dos dimensiones creado con Godot para Android.

El jugador debe sobrevivir durante 45 segundos, saltando obstáculos y cambiando
entre las dimensiones cyan y magenta al compás de 120 BPM.

## Estado

- Motor: Godot 4.7.1.
- Plataforma principal: Android en orientación horizontal.
- Versión del MVP: `0.2.0`.
- Renderizador: GL Compatibility.
- APK más reciente: `release/RiftBeat-latest.apk`.
- Pruebas automatizadas: `tests/smoke_test.gd`.

El estado vigente y el siguiente paso exacto se mantienen en
[`docs/ESTADO_ACTUAL.md`](docs/ESTADO_ACTUAL.md).

## Continuidad

Antes de modificar el proyecto:

1. Leer este archivo.
2. Leer completamente `docs/ESTADO_ACTUAL.md`.
3. Revisar las últimas entradas de `docs/BITACORA.md`.
4. Leer las decisiones vigentes de `docs/DECISIONES.md`.
5. Ejecutar `git status`, comprobar la rama y revisar el historial reciente.

La bitácora es acumulativa: las entradas anteriores no se borran ni se
reescriben.

## Controles

- Mitad izquierda de la pantalla: cambiar de dimensión.
- Botón central: usar **Rift Pulse** sobre un bloque agrietado cercano.
- Mitad derecha de la pantalla: saltar con el **Rift Roll**, un giro de cinco
  cuartos con dirección vinculada a la dimensión, estela y golpe de aterrizaje.
- Teclado para desarrollo: `Tab` cambia, `E` o `X` usa Rift Pulse, `Espacio`
  salta, `P` pausa y `R` reinicia.

En Android el juego se bloquea en horizontal automática: funciona en las dos
posiciones apaisadas del teléfono.

## Sistema modular de obstáculos

El catálogo registra 12 piezas básicas. Cada instancia combina seis grupos de
propiedades: dimensión, movimiento, gravedad, destrucción, ritmo y reacción.
La primera integración jugable incluye:

- prensa rítmica que se extiende y retrae por compases;
- zona de gravedad ligera que alarga el salto;
- bloque agrietado destructible con Rift Pulse.

Las otras nueve piezas están catalogadas para futuras combinaciones, pero no se
introducirán en etapas hasta validar estos tres prototipos.

El contrato, catálogo y reglas de introducción se mantienen en
[`docs/OBSTACULOS.md`](docs/OBSTACULOS.md).

## Ejecutar las pruebas

```powershell
godot_console --headless --path . --script res://tests/smoke_test.gd
godot_console --headless --path . --script res://tests/obstacle_system_test.gd
```

## Generar el APK

Con Godot 4.7.1, sus plantillas de exportación y el SDK Android configurados:

```powershell
powershell -ExecutionPolicy Bypass -File tools/export_android.ps1
```

El script ejecuta las pruebas antes de exportar y actualiza el checksum
`release/RiftBeat-latest.apk.sha256`.

## Estructura

```text
docs/
├── BITACORA.md
├── DECISIONES.md
└── ESTADO_ACTUAL.md
assets/
release/
scenes/
scripts/
tests/
tools/
```

La implementación visual y el sonido del pulso se generan proceduralmente; no
hay recursos audiovisuales de terceros.

## Repositorio

- Remoto oficial: `https://github.com/7yrak/RiftBeat.git`
- Rama principal: `main`
- Licencia: pendiente de definición.
