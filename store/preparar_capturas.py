"""Convierte capturas del móvil al formato que acepta Google Play.

Uso:  python3 store/preparar_capturas.py captura1.png captura2.png ...
Salida: store/capturas/NN.png  (1080x1920, 9:16, PNG 24 bits sin alfa)

Recorta por arriba y abajo (barra de estado / navegación) para llegar a
9:16; Play rechaza capturas cuyo lado largo supere el doble del corto.
"""
import pathlib
import sys

from PIL import Image

OUT = pathlib.Path(__file__).parent / "capturas"
OUT.mkdir(exist_ok=True)

for i, path in enumerate(sys.argv[1:], start=1):
    img = Image.open(path).convert("RGB")
    w, h = img.size
    target_h = round(w * 16 / 9)
    if h > target_h:
        top = (h - target_h) // 2
        img = img.crop((0, top, w, top + target_h))
    img = img.resize((1080, 1920), Image.LANCZOS)
    dest = OUT / f"{i:02d}.png"
    img.save(dest)
    print(f"{path} -> {dest}")
