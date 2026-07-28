# Sistema modular de obstáculos

Este documento define el contrato estable para construir obstáculos de RiftBeat.
No se crearán nuevas etapas hasta validar los tres primeros prototipos en un
dispositivo Android.

## Contrato de una pieza

Cada pieza declara los mismos seis grupos de propiedades:

1. **Dimensión**: carril cyan, carril magenta o ambos.
2. **Movimiento**: desplazamiento base, oscilación y escala de velocidad.
3. **Gravedad**: ausencia de efecto, zona o influencia radial, con su escala.
4. **Destructible**: vida, poder requerido y estado destruido.
5. **Ritmo**: período, fase y pulsos activos.
6. **Reacción**: daño, efecto, cambio dimensional y consecuencia al destruirse.

Las propiedades se combinan mediante modificadores anidados. Por ejemplo, un
`cracked_block` puede recibir movimiento oscilatorio y un patrón rítmico sin
crear otra clase ni perder su comportamiento destructible.

## Catálogo inicial

| ID | Pieza | Propiedad principal | Estado |
|---|---|---|---|
| `base_block` | Bloque base | Colisión por dimensión | Disponible |
| `tall_wall` | Muro alto | Altura | Catalogada |
| `dual_barrier` | Barrera gemela | Ambas dimensiones | Catalogada |
| `moving_block` | Bloque móvil | Oscilación | Catalogada |
| `pulse_spike` | Pico de pulso | Ritmo alternado | Catalogada |
| `rhythm_press` | Prensa rítmica | Extensión por compases | **Prototipo jugable** |
| `light_gravity_zone` | Gravedad ligera | Gravedad al 38 % | **Prototipo jugable** |
| `gravity_well` | Pozo gravitacional | Influencia radial | Catalogada |
| `cracked_block` | Bloque agrietado | Rift Pulse | **Prototipo jugable** |
| `phase_gate` | Compuerta de fase | Pulsos alternos | Catalogada |
| `chain_core` | Núcleo en cadena | Reacción al destruirse | Catalogada |
| `mirror_block` | Bloque espejo | Cambio dimensional | Catalogada |

“Catalogada” significa que la pieza tiene datos válidos y puede combinar
propiedades, pero todavía no se genera durante una partida. Esto evita introducir
mecánicas sin presentación, balance ni prueba física.

## Prototipos de la versión 0.2.0

### Prensa rítmica

- Patrón de cuatro pulsos.
- Está extendida durante los pulsos 0 y 1.
- Se retrae durante los pulsos 2 y 3.
- Solo causa daño cuando su estado rítmico está activo.
- Luces y opacidad anticipan si es peligrosa.

### Zona de gravedad ligera

- Afecta únicamente su dimensión.
- Reduce la gravedad del jugador al 38 %.
- Conserva la fuerza inicial del salto, produciendo un arco más largo.
- Las flechas ascendentes y el HUD comunican el efecto.
- No causa daño directo.

### Bloque agrietado y Rift Pulse

- El jugador comienza con tres cargas de Rift Pulse.
- El poder busca el objetivo destructible más cercano en la dimensión activa.
- El alcance es de 330 píxeles.
- Una carga solo se consume cuando existe un objetivo compatible.
- Las cargas recuperan una unidad al comenzar cada ciclo de 24 pulsos.
- El control táctil usa el botón central; en teclado se utiliza `E` o `X`.

## Reglas de diseño

- Una mecánica nueva se presenta sola antes de combinarse.
- Todo peligro rítmico debe anticipar visual y sonoramente su estado.
- Un poder no puede consumirse si no produce un efecto.
- Los portales futuros deben mostrar o anticipar su destino.
- Los obstáculos de otra dimensión permanecen visibles con menor intensidad.
- Las combinaciones no crearán scripts nuevos salvo que el contrato de seis
  propiedades resulte insuficiente.
- Las nueve piezas catalogadas no entrarán en etapas hasta validar comprensión,
  respuesta táctil, dificultad y rendimiento de los tres prototipos.

## Próxima validación de diseño

Jugar al menos tres partidas de la versión `0.2.0` y responder:

1. ¿La prensa comunica claramente cuándo hace daño?
2. ¿La gravedad ligera se percibe inmediatamente en el salto?
3. ¿El botón central y el alcance de Rift Pulse resultan naturales?
4. ¿Tres cargas iniciales y la recuperación por ciclo son suficientes?
5. ¿Algún prototipo se confunde con un bloque normal?

Solo después de esa validación se decidirá qué piezas catalogadas forman el
primer conjunto de etapas.
