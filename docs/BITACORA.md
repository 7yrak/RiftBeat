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

## Sesión 002 - 2026-07-27 22:50 America/Santiago

### Objetivo

Crear una primera versión jugable de RiftBeat para Android y preparar una
carpeta `release/` con el APK más reciente.

### Estado inicial

- `main` estaba limpio y sincronizado con `origin/main`.
- El repositorio contenía solo la base documental.
- No estaban instalados Godot, ADB ni el SDK Android.
- Java 21.0.11 LTS ya estaba disponible.

### Trabajo realizado

- Se definió un MVP de 45 segundos a 120 BPM.
- Se instaló y verificó Godot 4.7.1 estable.
- Se instalaron Platform Tools 37.0.0, Build Tools 35.0.1 y Platform 35.
- Se creó el proyecto Godot con renderizador GL Compatibility y orientación
  horizontal.
- Se implementaron salto, cambio entre dimensiones, obstáculos rítmicos,
  colisiones, vidas, puntuación, combo, victoria, derrota, pausa y reinicio.
- Se agregaron controles táctiles por mitades de pantalla y controles de teclado
  para desarrollo.
- Se crearon gráficos, icono y pulsos de audio procedurales.
- Se agregó una prueba automatizada y una prueba de captura renderizada.
- Se preparó `release/` y el script reproducible de exportación Android.

### Archivos creados

- `project.godot`
- `export_presets.cfg`
- `assets/icon.svg`
- `scenes/main.tscn`
- `scripts/game.gd`
- `tests/smoke_test.gd`
- `tests/capture_preview.gd`
- `tools/export_android.ps1`
- `release/README.md`

### Archivos modificados

- `.gitignore`
- `README.md`
- `docs/BITACORA.md`
- `docs/ESTADO_ACTUAL.md`
- `docs/DECISIONES.md`

### Decisiones técnicas

- Android se convirtió en la plataforma principal.
- Se eligió Godot 4.7.1 estable con GDScript y GL Compatibility.
- El APK estable se versionará en `release/`; otros APK seguirán ignorados.
- La primera versión usará firma debug para pruebas y no almacenará keystores ni
  contraseñas en Git.

### Comandos relevantes

```powershell
winget install --id GodotEngine.GodotEngine --exact
godot_console --headless --editor --path . --quit-after 3
godot_console --headless --path . --script res://tests/smoke_test.gd
godot_console --path . --script res://tests/capture_preview.gd
powershell -ExecutionPolicy Bypass -File tools/export_android.ps1
```

### Pruebas y resultados

- Importación Godot 4.7.1: aprobada.
- Prueba headless de escena y controles: aprobada.
- Prueba de generación rítmica: aprobada.
- Prueba de colisión y salto evasivo: aprobada.
- Prueba de condición de victoria: aprobada.
- Captura de portada a 1280×720: aprobada.
- Captura de partida y controles táctiles: aprobada.
- Exportación Android: pendiente de finalizar la descarga de plantillas.

### Errores encontrados

- El instalador de JDK 17 quedó esperando sin completar.
- La primera prueba no liberaba todas las referencias al cerrar.
- Godot apuntaba a una instalación Android SDK incompleta.
- El nuevo Android CLI devolvió código 1 pese a instalar correctamente los tres
  componentes solicitados.

### Soluciones aplicadas

- Se conservó Java 21, compatible con Godot, y se detuvo solo el proceso
  `winget` iniciado por la sesión.
- La prueba ahora libera la escena y el audio antes de terminar.
- Se configuró Godot hacia el SDK completo en
  `%LOCALAPPDATA%\Android\Sdk`.
- Se verificó cada binario y paquete Android directamente en disco.

### Problemas pendientes

- Completar e instalar las plantillas de exportación.
- Generar el APK y comprobar firma, versión, tamaño y checksum.
- Probar el APK en un dispositivo Android físico.
- Definir una licencia para el repositorio.

### Riesgos o deuda técnica

- La dificultad todavía no se ha calibrado mediante juego real.
- El audio es un metrónomo sintetizado, no una pista musical.
- La firma debug sirve para pruebas, no para publicar en Google Play.

### Commit asociado

`feat: implement dual dimension rhythm gameplay`

### Próximo paso recomendado

Generar `release/RiftBeat-latest.apk`, verificarlo y probarlo en un dispositivo
Android antes de diseñar contenido adicional.

### Avance de entorno - 2026-07-27 22:53 America/Santiago

- Android Command Line Tools se verificó contra el SHA-256 oficial
  `90ae805d20434428bffcb699c290860f19bb5f66a67e6b330067e3de801fb04a`.
- Las plantillas Godot 4.7.1 se verificaron contra el SHA-256 oficial
  `86409db6200b6f8fd3230989c2d2002851f3dd18acf11d7bdbafddf5a0dd0f72`.
- Se instalaron únicamente `android_debug.apk`, `android_release.apk` y su
  archivo de versión en la carpeta local de plantillas.
- La prueba headless ampliada terminó sin errores ni objetos filtrados.
- Ya no existen bloqueos técnicos conocidos para intentar la exportación.

### Cierre de versión - 2026-07-27 22:59 America/Santiago

#### Trabajo completado

- Se corrigió la exportación eliminando opciones de SDK que requerían Gradle y
  habilitando compresión ETC2/ASTC.
- Se instalaron Build Tools 36.0.0 y Platform 36 para coincidir con el Target SDK
  de la plantilla.
- Se excluyeron pruebas, herramientas y documentación del paquete final.
- Se agregaron capas de icono principal, adaptativa y monocroma para Android.
- Se generó `release/RiftBeat-latest.apk` desde el commit fuente
  `0904ca01b0736c042b75d1693158c47abc4dc5d1`.
- Se generó el checksum y el registro `release/VERSION.md`.

#### Validación final

- Prueba headless: aprobada sin fugas.
- Exportación Android: aprobada.
- Paquete: `com.sevenyrak.riftbeat`.
- Versión: `0.1.0` (`versionCode` 1).
- Arquitectura: `arm64-v8a`.
- Minimum SDK: 24.
- Target SDK: 36.
- Firma APK v2 y v3: aprobada.
- Alineación ZIP: aprobada.
- Contenido del paquete: aprobado; no incluye tests, tools ni docs.
- Tamaño: 28.558.755 bytes.
- SHA-256:
  `16f61dec93f81a989e571038ae4b56923590f33bd584b7d1ae0728d088a4432a`.
- Dispositivo ADB: no disponible; la instalación física queda pendiente.

#### Errores y soluciones

- La primera exportación rechazó `gradle_build/min_sdk` y
  `gradle_build/target_sdk` porque el preset no usa Gradle; se eliminaron.
- Android exigió ETC2/ASTC; se habilitó
  `textures/vram_compression/import_etc2_astc`.
- Build Tools 35.0.1 no coincidía con Target SDK 36; se instaló 36.0.0.
- `aapt2` mantiene una advertencia no bloqueante del icono temático opcional del
  template Godot 4.7.1. Firma, alineación e iconos exportados son válidos.

#### Commit asociado

`chore: publish Android MVP 0.1.0`

#### Próximo paso

Instalar el APK en un teléfono Android ARM64, jugar tres partidas completas y
registrar feedback de dificultad, controles táctiles, audio y rendimiento.

## Sesión 003 - 2026-07-27 23:09 America/Santiago

### Objetivo

Dar al salto una identidad rotatoria propia inspirada en la claridad de los
arcades de cubo y corregir el juego para Android horizontal.

### Estado inicial

- `main` estaba limpio y sincronizado con `origin/main`.
- La versión estable era `0.1.0`.
- El personaje saltaba sin rotación y conservaba una silueta pentagonal.
- El viewport era 1280×720, pero
  `display/window/handheld/orientation=1` solicitaba orientación vertical en
  Android.

### Trabajo realizado

- Se diseñó el **Rift Roll** con cinco cuartos de giro por salto.
- El giro es horario en cyan y antihorario en magenta.
- Se reemplazó el personaje por un cubo de dos colores con núcleo de grieta.
- Se agregaron estela rotatoria, sombra dependiente de altura, squash de
  despegue y onda de impacto al aterrizar.
- Android pasó a horizontal automática mediante
  `SCREEN_SENSOR_LANDSCAPE` (`4`), compatible con ambos sentidos apaisados.
- La versión de aplicación y exportación avanzó a `0.1.1` (`versionCode` 2).
- La captura de QA ahora muestra el salto y libera correctamente la escena.

### Pruebas y resultados

- Prueba headless de escena y mecánicas existentes: aprobada.
- Verificación automatizada de viewport horizontal: aprobada.
- Verificación automatizada de orientación Android `4`: aprobada.
- Giro, estela, encaje al aterrizar e impacto visual: aprobados.
- Captura renderizada 1280×720 durante el salto: aprobada.
- La captura terminó sin objetos filtrados.

### Problemas encontrados

- El valor de orientación `1` no significaba horizontal en Godot 4; corresponde
  a orientación vertical.
- La captura de QA cerraba la escena en el mismo frame y Godot informaba una
  instancia filtrada.

### Soluciones aplicadas

- Se confirmó la enumeración oficial de Godot y se configuró el valor `4`.
- La prueba de captura ahora libera la escena, espera dos frames y luego termina.

### Problemas pendientes

- Generar y validar el APK `0.1.1`.
- Probar el giro y ambas posiciones horizontales en un teléfono Android.
- Definir una licencia para el repositorio.

### Próximo paso recomendado

Crear el commit fuente de `0.1.1`, exportar el APK desde ese commit y repetir las
verificaciones de firma, alineación, metadatos, arquitectura y checksum.

### Cierre de versión - 2026-07-27 23:11 America/Santiago

#### Artefacto generado

- APK: `release/RiftBeat-latest.apk`.
- Versión: `0.1.1` (`versionCode` 2).
- Commit fuente: `4751e9a88f35dcf176419b0880caca792d2e083e`.
- Paquete: `com.sevenyrak.riftbeat`.
- Arquitectura: `arm64-v8a`.
- Tamaño: 28.562.851 bytes.
- SHA-256:
  `f20f051abb084cfcf7d7fbc7113e2f6f24b37fd31cc60560a2ba928d3141d283`.

#### Validación final

- Exportación Android: aprobada.
- Firma APK v2 y v3: aprobada.
- Alineación ZIP: aprobada.
- Minimum SDK 24 y Target SDK 36: aprobados.
- Manifiesto Android con orientación horizontal: aprobado.
- Única biblioteca nativa `arm64-v8a`: aprobada.
- Tests, herramientas y documentos excluidos del APK: aprobado.
- Checksum reproducido desde el archivo final: aprobado.
- Dispositivo ADB: no disponible; la instalación física queda pendiente.

#### Próximo paso

Instalar la versión `0.1.1` en un teléfono ARM64, verificar ambas orientaciones
apaisadas y jugar tres partidas para calibrar el Rift Roll.
