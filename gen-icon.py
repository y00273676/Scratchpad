#!/usr/bin/env python3
"""Generate app icon for Scratchpad."""
from PIL import Image, ImageDraw

SIZES = [16, 32, 128, 256, 512]
CORNERS = {
    16: 4, 32: 7, 128: 28, 256: 55, 512: 110,
}

BG = (26, 26, 29, 255)       # #1a1a1d
BAR = (138, 138, 142, 255)   # #8a8a8e


def draw_icon(size: int) -> Image.Image:
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    r = CORNERS.get(size, int(size * 0.215))
    draw.rounded_rectangle([0, 0, size - 1, size - 1], radius=r, fill=BG)

    bar_h = max(int(size * 0.04), 2)
    bar_w = int(size * 0.48)
    gap = int(size * 0.06)
    x = (size - bar_w) // 2
    top = int(size * 0.30)

    for i in range(3):
        y = top + i * (bar_h + gap)
        draw.rounded_rectangle(
            [x, y, x + bar_w, y + bar_h],
            radius=bar_h // 2,
            fill=BAR,
        )

    return img


def main():
    iconset = "build/AppIcon.iconset"
    import os
    os.makedirs(iconset, exist_ok=True)

    for s in SIZES:
        img = draw_icon(s)
        img.save(f"{iconset}/icon_{s}x{s}.png")
        img.save(f"{iconset}/icon_{s//2}x{s//2}@2x.png")

    # 1024 for App Store (not needed for local, but nice)
    img = draw_icon(1024)
    img.save(f"{iconset}/icon_512x512@2x.png")

    os.system(f"iconutil -c icns -o build/AppIcon.icns {iconset}")
    print("build/AppIcon.icns created")


if __name__ == "__main__":
    main()
