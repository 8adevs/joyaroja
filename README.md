# Joya Roja – Mantra de Riqueza

App minimalista para Android que ayuda a crear el hábito diario de repetir un mantra enfocado en la prosperidad, la disciplina y los objetivos personales. Cada día envía un recordatorio a la hora elegida; durante la sesión, una joya roja brilla mientras repites tu mantra.

## Características

- 10 mantras sobre abundancia, gratitud, confianza, enfoque y acción.
- Recordatorio diario a la hora que elijas.
- Sesiones de 1 a 10 minutos con sonido ambiental.
- Modo de mantra aleatorio, tema oscuro y claro, español e inglés.
- Sin anuncios, sin cuentas y sin conexión a internet: las preferencias se guardan solo en el dispositivo.

## Privacidad

La app no recopila ni comparte datos. Política completa: <https://8adevs.github.io/joyaroja/privacy.html>

## Desarrollo

Requisitos: Flutter 3.44 o superior (Android: `minSdk` 24, `targetSdk` 36).

```bash
flutter pub get
flutter run
```

### Build de release

La firma usa un keystore local que **no** se versiona. Crea `android/key.properties`:

```
storePassword=...
keyPassword=...
keyAlias=upload
storeFile=/ruta/a/joyaroja-upload.jks
```

y genera el bundle para Google Play:

```bash
flutter build appbundle --release
```

Sin `key.properties` el build de release se firma con la clave de debug (válido solo para pruebas locales).

## Estructura

- `lib/`: código de la app (pantallas, providers, servicios).
- `assets/`: traducciones, audio, imágenes y fuentes incluidas.
- `docs/`: sitio de GitHub Pages con la política de privacidad.
- `store/`: material para la ficha de Google Play y guía de publicación.

---

Desarrollado por **8adevs** · Contacto: joyaroja.app@gmail.com
