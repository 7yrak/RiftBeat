# Bitácora de RiftBeat

Historial cronológico y permanente del proyecto. Las nuevas sesiones se agregan
al final sin borrar ni reescribir las anteriores.

## Sesión 001 - 2026-07-27 22:24 America/Santiago

### Objetivo

Verificar el repositorio oficial e inicializar una base segura de control de
versiones y continuidad para RiftBeat.

### Estado inicial

- La carpeta local `D:\workspace\proyectos\RiftBeat` estaba vacía.
- La carpeta no era un repositorio Git.
- El repositorio remoto `7yrak/RiftBeat` existía, era público y estaba vacío.
- La cuenta autenticada era `7yrak` y tenía permiso `ADMIN` sobre el remoto.
- GitHub CLI fue instalado durante la sesión, pero la consola inicial todavía no
  tenía su ruta actualizada.
- No existían README, proyecto Godot, código, pruebas ni documentación previa.

### Trabajo realizado

- Se verificó la autenticación de GitHub sin registrar credenciales.
- Se confirmó la URL, visibilidad, permiso y ausencia de historial remoto.
- Se inicializó Git con `main` como rama principal.
- Se configuró únicamente el repositorio oficial como remoto `origin`.
- Se creó un `.gitignore` para Godot, Android, Java, IDE, sistemas operativos,
  archivos temporales y material sensible.
- Se creó un README inicial sin inventar requisitos de producto.
- Se crearon los documentos obligatorios de bitácora, estado y decisiones.

### Archivos creados

- `.gitignore`
- `README.md`
- `docs/BITACORA.md`
- `docs/ESTADO_ACTUAL.md`
- `docs/DECISIONES.md`

### Archivos modificados

- Ninguno; la carpeta estaba vacía.

### Decisiones técnicas

- Se usó `main` porque es la rama principal requerida para el repositorio.
- Se mantuvo `https://github.com/7yrak/RiftBeat.git` como único remoto.
- No se creó todavía `project.godot`: faltan la versión objetivo del motor y la
  definición del MVP, y asumirlas crearía deuda innecesaria.
- Se excluyeron credenciales de exportación, keystores, claves y archivos de
  entorno con valores reales.

### Comandos relevantes

```powershell
git status
gh auth status
gh repo view 7yrak/RiftBeat
git ls-remote --symref https://github.com/7yrak/RiftBeat.git HEAD
git init -b main
git remote add origin https://github.com/7yrak/RiftBeat.git
git remote -v
java -version
```

### Pruebas y resultados

- Inspección de la carpeta: aprobada; estaba vacía.
- Estado Git inicial: aprobado; confirmó que no era un repositorio.
- Autenticación de GitHub: aprobada; cuenta activa `7yrak`.
- Acceso al remoto: aprobado; permiso `ADMIN`.
- Inspección del remoto: aprobada; no contenía ramas, archivos ni commits.
- Verificación de Java: aprobada; Java 21.0.11 LTS disponible.
- Validación Godot: no ejecutable; `godot` y `godot4` no están disponibles.
- Validación Gradle: no ejecutable; `gradle` no está disponible.
- Pruebas del juego: no aplican; todavía no existe un proyecto ejecutable.

### Errores encontrados

- Tras instalar GitHub CLI, la consola abierta no reconocía `gh` porque conservaba
  el `PATH` anterior.
- Una consulta inicial de herramientas falló por interpolar una variable seguida
  de `:` sin delimitarla en PowerShell.

### Soluciones aplicadas

- Se localizó `gh.exe` en `C:\Program Files\GitHub CLI\gh.exe`; el usuario agregó
  temporalmente la carpeta al `PATH` y completó la autenticación.
- La consulta de herramientas se corrigió delimitando la variable de PowerShell.

### Problemas pendientes

- Definir el concepto jugable y el alcance verificable del MVP.
- Elegir y documentar la versión de Godot.
- Instalar Godot y, cuando sea necesario, el entorno de exportación Android.
- Crear el proyecto mínimo y una prueba de arranque headless.

### Riesgos o deuda técnica

- No existe aún un ejecutable que permita validar compatibilidad con Godot o
  Android.
- La licencia del repositorio no está definida.
- El porcentaje del MVP es provisional hasta acordar su alcance.

### Commit asociado

`chore: initialize RiftBeat project`

### Próximo paso recomendado

Definir el MVP y la versión objetivo de Godot; después crear un proyecto mínimo
que pueda importarse y arrancar en modo headless.

### Cierre verificado - 2026-07-27 22:27 America/Santiago

- El commit `70993c5cfe18b0034858fba7f03c50fc12a56529` se publicó en
  `origin/main`.
- `git ls-remote`, la referencia `origin/main` y la API de GitHub devolvieron el
  mismo hash.
- GitHub confirmó `main` como rama predeterminada y mantuvo la visibilidad
  pública del repositorio.
- Se refinó `.gitignore` para permitir el Gradle Wrapper y un eventual
  `android/build` personalizado de Godot, sin dejar de excluir salidas Gradle.
- El cierre documental se asocia al commit `docs: update project log`.
- No quedaron cambios locales desconocidos ni secretos detectados.
