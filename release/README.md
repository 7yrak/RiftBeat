# Releases Android

Esta carpeta conserva la última versión Android estable y verificable de
RiftBeat.

## Archivos esperados

- `RiftBeat-latest.apk`: APK instalable más reciente.
- `RiftBeat-latest.apk.sha256`: checksum SHA-256 del APK.
- `VERSION.md`: versión, commit de origen, fecha y resultado de validación.

Los APK temporales o de pruebas no deben copiarse aquí. Cada reemplazo del APK
estable debe actualizar también su checksum, la versión y la bitácora.

## Instalar en un dispositivo conectado

Con depuración USB habilitada:

```powershell
adb install -r release/RiftBeat-latest.apk
```

También puedes copiar `RiftBeat-latest.apk` al teléfono y abrirlo desde el
administrador de archivos, autorizando temporalmente la instalación desde esa
fuente.
