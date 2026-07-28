# Decisiones de RiftBeat

Registro acumulativo de decisiones técnicas y de producto. Una decisión vigente
no se modifica silenciosamente: cualquier reemplazo se documenta mediante un
nuevo ADR.

## ADR-001 - Repositorio oficial y rama principal

- Fecha: 2026-07-27.
- Estado: aceptada.
- Problema: establecer una única fuente de verdad para el código y evitar
  historias divergentes o publicaciones accidentales.
- Alternativas consideradas:
  - Usar `7yrak/RiftBeat` con `main`.
  - Crear otro repositorio.
  - Mantener el proyecto únicamente de forma local.
- Decisión: usar exclusivamente
  `https://github.com/7yrak/RiftBeat.git`, con `main` como rama principal, sin
  pushes forzados.
- Motivo: el repositorio fue designado oficialmente y la continuidad requiere un
  historial remoto verificable.
- Consecuencias: todo push debe validar remoto, cambios, pruebas, secretos y
  documentación; los historiales remoto y local deben integrarse sin
  sobrescritura.
- Reversibilidad: baja dentro del proyecto actual; cambiar de repositorio exige
  autorización explícita y un nuevo ADR.

## ADR-002 - Documentación permanente de continuidad

- Fecha: 2026-07-27.
- Estado: aceptada.
- Problema: permitir que el proyecto pueda retomarse con seguridad en otra
  sesión, incluso sin el contexto de conversaciones anteriores.
- Alternativas consideradas:
  - Depender del historial de Git.
  - Mantener notas informales fuera del repositorio.
  - Versionar bitácora, estado vigente y decisiones.
- Decisión: mantener `docs/BITACORA.md`, `docs/ESTADO_ACTUAL.md` y
  `docs/DECISIONES.md` en cada avance significativo.
- Motivo: Git registra cambios, pero no conserva por sí solo todo el contexto,
  resultados de validación, riesgos y próximos pasos.
- Consecuencias: cada avance estable requiere actualizar los documentos antes del
  commit; la bitácora es cronológica y no se reescribe.
- Reversibilidad: media; el formato puede evolucionar mediante un nuevo ADR, pero
  no se eliminará el historial existente.

## ADR-003 - Posponer la creación del proyecto Godot

- Fecha: 2026-07-27.
- Estado: aceptada.
- Problema: la carpeta está vacía y todavía no se ha definido la versión de Godot
  ni el alcance del MVP.
- Alternativas consideradas:
  - Generar inmediatamente un proyecto Godot con supuestos predeterminados.
  - Inicializar primero el repositorio y acordar el producto y las herramientas.
- Decisión: crear primero la base de repositorio y continuidad; crear
  `project.godot` después de confirmar el MVP y la versión del motor.
- Motivo: evita fijar arquitectura, renderizador, resolución o dependencias sin
  requisitos confirmados.
- Consecuencias: por ahora no hay compilación ni prueba headless; la siguiente
  sesión debe cerrar esas definiciones antes de implementar mecánicas.
- Reversibilidad: alta; la decisión queda superada en cuanto se documenten los
  requisitos y se cree el proyecto mínimo mediante un nuevo avance.

## ADR-004 - Alcance del primer MVP jugable

- Fecha: 2026-07-27.
- Estado: aceptada; reemplaza el aplazamiento de ADR-003.
- Problema: se necesita una primera versión concreta que pueda probarse en
  Android sin disponer todavía de un documento de diseño completo.
- Alternativas consideradas:
  - Esperar una especificación exhaustiva.
  - Crear un prototipo de escritorio.
  - Crear directamente un arcade rítmico táctil para Android.
- Decisión: implementar una partida de 45 segundos a 120 BPM con avance
  automático, salto, dos dimensiones, obstáculos, tres vidas, puntuación,
  victoria, derrota, pausa y reinicio.
- Motivo: materializa las pistas funcionales del proyecto y permite obtener
  feedback temprano en el dispositivo objetivo.
- Consecuencias: el MVP prioriza un bucle corto y legible; contenido, música,
  niveles y progresión quedan para iteraciones posteriores.
- Reversibilidad: alta; duración, dificultad y patrón pueden ajustarse sin
  reemplazar la arquitectura.

## ADR-005 - Android como plataforma principal y carpeta release

- Fecha: 2026-07-27.
- Estado: aceptada.
- Problema: la versión de prueba debe ser instalable en Android y debe existir un
  lugar estable para encontrar el último artefacto.
- Alternativas consideradas:
  - Entregar solo el proyecto Godot.
  - Publicar únicamente compilaciones de escritorio.
  - Conservar el APK estable en `release/`.
- Decisión: Android horizontal es el objetivo principal; el último APK aprobado,
  su checksum y sus metadatos se mantienen en `release/`.
- Motivo: permite probar el juego sin abrir el editor y hace explícito qué
  binario corresponde a la versión vigente.
- Consecuencias: `.gitignore` admite únicamente APK estables dentro de
  `release/`; los APK temporales siguen excluidos.
- Reversibilidad: media; una futura distribución mediante GitHub Releases puede
  reemplazar el almacenamiento del binario mediante un nuevo ADR.

## ADR-006 - Godot 4.7.1, GDScript y visuales procedurales

- Fecha: 2026-07-27.
- Estado: aceptada.
- Problema: elegir una base técnica estable, pequeña y exportable a Android.
- Alternativas consideradas:
  - Godot 4.7.1 con GDScript.
  - Godot con C#.
  - Recursos gráficos y audio externos desde la primera versión.
- Decisión: usar Godot 4.7.1 estable, GDScript, GL Compatibility y gráficos y
  pulso sonoro generados en tiempo de ejecución.
- Motivo: reduce dependencias, licencias de recursos y tamaño del proyecto, y
  mantiene compatibilidad amplia con Android.
- Consecuencias: el estilo visual es abstracto y la música se limita por ahora a
  pulsos sintetizados; deberá evolucionar si el prototipo valida su jugabilidad.
- Reversibilidad: alta; pueden añadirse recursos y sistemas separados sin romper
  el bucle principal.
