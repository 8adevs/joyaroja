# Imágenes de la Joya

Coloca aquí **exactamente dos archivos PNG** antes de construir el APK:

| Archivo           | Descripción                                              |
|-------------------|----------------------------------------------------------|
| `jewel_base.png`  | La gema sin brillo interno (fondo transparente)          |
| `jewel_glow.png`  | La misma gema con brillo cálido interno (fondo transparente) |

## Requisitos de los archivos
- Formato: **PNG** con canal alpha (fondo transparente)
- Tamaño recomendado: **600 × 600 px** o superior (la app los escala a 220 dp)
- Los dos archivos deben tener exactamente las mismas dimensiones para que la superposición sea perfecta

## Cómo se usan
Las dos imágenes se superponen en `lib/widgets/jewel_widget.dart`:
1. `jewel_base.png` — siempre visible, opacidad fija
2. `jewel_glow.png` — se anima encima con opacidad pulsante (0 % en reposo → 100 % en sesión activa)
Un bloom cálido semi-opaco (#FF5030) se dibuja en el centro para reforzar el efecto de luz interna.

La misma `JewelWidget` se usa en SplashScreen y en HomeScreen.
