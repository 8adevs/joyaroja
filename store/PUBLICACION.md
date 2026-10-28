# Publicación en Google Play – Joya Roja – Mantra de Riqueza

Material listo para copiar y pegar en Play Console. Desarrollador público: **8adevs** · Contacto: **joyaroja.app@gmail.com**

> Todos los comandos se ejecutan en una terminal abierta en la **carpeta raíz del proyecto** (`mantra_de_la_riqueza/`), salvo que se indique otra cosa.

---

## Fase 0 – Estado técnico

| Requisito de Google | Estado |
|---|---|
| ID de paquete propio (`com.joyaroja`) | ✅ |
| Target API 36 (obligatorio desde el 31-ago-2026) | ✅ `targetSdk=36`, `minSdk=24` |
| Formato `.aab` | ✅ `build/app/outputs/bundle/release/app-release.aab` |
| Sin alarmas exactas | ✅ Permisos finales: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `VIBRATE` |
| Sin `INTERNET` ni `AD_ID` | ✅ Las fuentes van incluidas en la app |
| Política de privacidad dentro de la app | ✅ Ajustes → Política de privacidad |
| Textos sin promesas de resultados | ✅ El onboarding ya no dice "manifestar riqueza" |
| Firma con clave de subida | ✅ Certificado `CN=8adevs` (`~/joyaroja-upload.jks`) |

Comandos pendientes:
```bash
keytool -genkey -v -keystore ~/joyaroja-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
# crea android/key.properties (ver instrucciones anteriores) y luego:
flutter build appbundle --release
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab | head -5   # NO debe decir "Android Debug"
```
Haz una copia de seguridad del `.jks` y de su contraseña fuera del ordenador.

---

## Fase 1 – Material previo

### 1.1 Email dedicado
Crea la cuenta de Gmail `joyaroja.app@gmail.com` (ya está puesta en la app, la web y este documento).

### 1.2 Política de privacidad en GitHub Pages (gratis)

Los archivos ya están listos en `store/github-pages/`. Se usa una **organización** `8adevs` para que la URL no muestre tu nombre.

1. Entra en GitHub con tu cuenta → avatar → **Your organizations** → **New organization** → plan **Free**.
   - Nombre: `8adevs`. Si está ocupado, elige otro y cámbialo en `lib/screens/privacy_screen.dart` (`kPrivacyPolicyUrl`).
   - Email de contacto: `joyaroja.app@gmail.com`.
2. Dentro de la organización: **New repository**.
   - Nombre exacto: **`8adevs.github.io`**
   - Visibilidad: **Public** (Pages gratis solo funciona con repos públicos).
   - Marca "Add a README".
3. **Add file → Upload files** → arrastra el **contenido** de `store/github-pages/` (`index.html` y la carpeta `joyaroja/`) → **Commit changes**.
4. **Settings → Pages** → *Source: Deploy from a branch* → rama `main`, carpeta `/ (root)` → **Save**.
5. Espera 1-2 minutos y abre en modo incógnito: **https://8adevs.github.io/joyaroja/privacy.html**
6. Comprueba que carga sin iniciar sesión y que el email es el correcto.

Alternativa por terminal (después del paso 2):
```bash
git clone git@github.com:8adevs/8adevs.github.io.git ~/8adevs.github.io
cp -r store/github-pages/* ~/8adevs.github.io/
cd ~/8adevs.github.io && git add . && git commit -m "Política de privacidad Joya Roja" && git push
```

La política cumple los requisitos de Google: está identificada como "Política de privacidad", nombra la app y al desarrollador e incluye contacto, datos tratados, permisos, terceros, conservación y eliminación, seguridad, menores y cambios. Además está en una URL pública que no es un PDF y está en ES y EN.

### 1.3 Gráficos (ya generados en `store/graficos/`)

| Recurso | Archivo | Requisito de Google |
|---|---|---|
| Icono | `icono-512.png` | 512×512, PNG de 32 bits, < 1 MB ✅ |
| Gráfico destacado | `grafico-destacado-1024x500.png` | 1024×500, PNG de 24 bits sin alfa ✅ |
| Capturas | **Las haces tú** (ver abajo) | De 2 a 8; recomendado 4 o más a 1080×1920, sin alfa, proporción ≤ 2:1 |

**Cómo hacer las capturas:**
1. Instala la app en tu móvil (`flutter run --release`), con tema oscuro y en español.
2. Captura estas 5 pantallas, con el botón del móvil o con `adb exec-out screencap -p > cap1.png`:
   1. Inicio con la joya
   2. Sesión activa (joya brillando)
   3. Lista de mantras
   4. Ajustes con la hora del recordatorio
   5. Un paso del tutorial
3. Que no aparezcan notificaciones personales en la barra de estado.
4. Conviértelas al formato de Play: `python3 store/preparar_capturas.py cap1.png cap2.png ...` → `store/capturas/`

---

## Fase 2 – Play Console

### 2.1 Contenido de la app (Política → Contenido de la aplicación)

| Sección | Respuesta |
|---|---|
| **Política de privacidad** | `https://8adevs.github.io/joyaroja/privacy.html` |
| **Acceso a la app** | "Toda la funcionalidad está disponible sin acceso especial" |
| **Anuncios** | "No, mi app no contiene anuncios" |
| **ID de publicidad** | "No" (la app no declara `AD_ID`) |
| **Clasificación de contenido** | Ver 2.2 |
| **Público objetivo** | Franjas **13-15, 16-17 y 18 o más** (o solo 18+ si prefieres una revisión más simple). "¿Podría atraer a niños sin querer?" → **No** |
| **Seguridad de los datos** | Ver 2.3 |
| **Apps gubernamentales** | No |
| **Funciones financieras** | "Mi app no ofrece ninguna función financiera" |
| **Salud** | "Mi app no ofrece ninguna función de salud" * |
| **Apps de noticias** | No |

\* Google considera función de salud la "gestión del estrés, relajación, mindfulness y meditación". Joya Roja es una herramienta de hábitos y afirmaciones, y la descripción de la ficha evita prometer relajación o reducción del estrés. Mantén ese enfoque en futuras versiones. Si algún día añades meditación guiada o respiración, cambia la respuesta a *Stress Management, Relaxation, Mental Acuity*.

### 2.2 Cuestionario de clasificación (IARC)

- Email: `joyaroja.app@gmail.com`. Categoría: **Todos los demás tipos de apps**.
- Responde **No** a todo: violencia, miedo, sexualidad, lenguaje soez, sustancias controladas, apuestas y simulaciones de apuestas, humor crudo, interacción o contenido entre usuarios, compartir ubicación, compras digitales, navegador o buscador, noticias.
- Resultado esperado: **PEGI 3 / Para todos / ESRB Everyone**.

### 2.3 Seguridad de los datos

1. "¿Tu app recopila o comparte alguno de los tipos de datos de usuario obligatorios?" → **No**
2. Revisa el resumen: "No se recopilan datos · No se comparten datos" → Guardar.

Es correcto porque los datos que se guardan solo en el dispositivo y nunca se envían fuera de él no cuentan como "recopilados" para Google. No hay cuentas, así que no aplica la eliminación de cuentas.

### 2.4 Categoría y datos de contacto (Presencia en tienda → Configuración de la ficha)

- Tipo: **Aplicación** · Categoría: **Estilo de vida**
- Etiquetas: hasta 5 de las que proponga Google, relacionadas con hábitos y motivación.
- Email: `joyaroja.app@gmail.com` (obligatorio) · Sitio web: `https://8adevs.github.io` · Teléfono: vacío.

### 2.5 Ficha principal – Español (idioma predeterminado: es-419 o es-ES)

**Nombre (29/30):**
```
Joya Roja – Mantra de Riqueza
```

**Descripción breve (68/80):**
```
Recibe un recordatorio diario para repetir tu mantra de prosperidad.
```

**Descripción completa:**
```
Dedica unos minutos al día a repetir un mantra enfocado en la prosperidad, la disciplina y tus objetivos personales.

Joya Roja es una aplicación minimalista que te ayuda a crear el hábito de practicar afirmaciones positivas cada día. A la hora que elijas recibirás un recordatorio: abre la app, contempla la joya roja y repite tu mantra durante el tiempo que hayas definido.

Características
• 10 mantras sobre abundancia, gratitud, confianza, enfoque y acción.
• Recordatorio diario a la hora que tú elijas.
• Sesiones de 1 a 10 minutos con sonido ambiental suave.
• Modo de mantra aleatorio para variar cada día.
• Tema oscuro y tema claro.
• Disponible en español e inglés.
• Sin anuncios, sin registro y sin necesidad de internet.
• Tus preferencias se guardan solo en tu teléfono.

¿Cómo funciona?
1. Elige tu mantra y memorízalo.
2. Define la hora de tu recordatorio diario.
3. Cuando llegue la notificación, abre la app.
4. Inicia la sesión y repite tu mantra mientras la joya brilla.
5. Continúa con tu día.

La constancia es la base de cualquier hábito. Joya Roja te ofrece un espacio sencillo y sin distracciones para mantener tu práctica diaria de enfoque personal.

Importante: Joya Roja es una herramienta de motivación y desarrollo personal. No garantiza resultados económicos ni sustituye el asesoramiento financiero o profesional.
```

### 2.6 Traducción opcional – Inglés (en-US)

Es gratis y aumenta el alcance, porque la app ya está traducida. Se añade en *Ficha de Play Store → Gestionar traducciones*. Puedes reutilizar los gráficos.

**Name (23/30):** `Red Gem – Wealth Mantra`

**Short description (70/80):**
```
A daily reminder to repeat your prosperity mantra and build the habit.
```

**Full description:**
```
Spend a few minutes a day repeating a mantra focused on prosperity, discipline and your personal goals.

Red Gem is a minimalist app that helps you build the habit of practicing positive affirmations every day. At the time you choose you'll get a reminder: open the app, look at the red gem and repeat your mantra for as long as you've set.

Features
• 10 mantras about abundance, gratitude, confidence, focus and action.
• Daily reminder at the time you choose.
• 1 to 10 minute sessions with soft ambient sound.
• Random mantra mode for daily variety.
• Dark and light themes.
• Available in English and Spanish.
• No ads, no sign-up, no internet required.
• Your preferences stay on your phone.

How it works
1. Choose your mantra and memorize it.
2. Set your daily reminder time.
3. When the notification arrives, open the app.
4. Start the session and repeat your mantra while the gem glows.
5. Carry on with your day.

Consistency is the foundation of any habit. Red Gem gives you a simple, distraction-free space to keep up your daily practice of personal focus.

Important: Red Gem is a motivation and personal development tool. It does not guarantee financial results and is not a substitute for financial or professional advice.
```

### 2.7 Reglas de metadatos que cumple esta ficha

- No hay emojis, mayúsculas de énfasis ni símbolos repetidos en el título ni en la descripción breve.
- No usa palabras como "mejor", "#1", "top", "gratis", "nuevo" ni llamadas a la acción del tipo "descarga ya".
- No promete riqueza ni resultados. Incluye un aviso explícito.
- No repite palabras clave para posicionarse.
- Las funciones descritas coinciden con lo que hace la app: 10 mantras, sesiones de 1-10 min, sonido, temas, ES/EN.

### 2.8 Precios

- **Precio: Gratis** (Monetización → Precio de la app).
- **Cuenta de comercio: no hace falta.** Solo se necesita para apps de pago o con compras integradas.
- ⚠️ Una app publicada como gratuita **no puede pasar a ser de pago** después.

---

## Fase 3 – Recordatorio

Si tu cuenta personal es posterior a noviembre de 2023, necesitas una **prueba cerrada con al menos 12 testers durante 14 días seguidos** antes de pedir acceso a producción. Google comprueba que los testers usen la app de verdad, así que pídeles que la abran varios días.
