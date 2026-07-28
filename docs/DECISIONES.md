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
