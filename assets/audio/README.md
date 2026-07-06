# Audio ambiente pendiente

`AudioService` espera un archivo en `assets/audio/ambient_bowl.mp3` (cuenco
tibetano, drone suave o similar). Aún no existe — agregarlo aquí y declarar
la ruta en `pubspec.yaml` (ya está incluida la carpeta `assets/audio/`
completa, así que basta con copiar el archivo).

Recomendaciones del archivo:
- Loop-friendly (sin clics al repetir), idealmente con crossfade en los
  extremos.
- Duración: 10–30 s es suficiente, `AudioService` lo reproduce en loop.
- Tamaño: <2 MB, 44.1kHz, mp3 o m4a.
