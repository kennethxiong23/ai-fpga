"Takes a greyscale PNG image and converts it to a text representation."

import sys
from PIL import Image
import os


def main():
    if len(sys.argv) != 2:
        print("Usage: python png_to_txt.py <image.png>")
        sys.exit(1)

    png_filename = sys.argv[1]

    # image.png -> image.txt
    base, _ = os.path.splitext(png_filename)
    txt_filename = base + ".txt"

    # Open image and force grayscale (0–255)
    img = Image.open(png_filename).convert("L")
    pixels = img.load()

    width, height = img.size

    with open(txt_filename, "w") as f:
        for y in range(height):
            for x in range(width):
                # two-digit hex, uppercase
                f.write(f"{pixels[x, y]:02X}\n")

    print(f"Saved hex pixel data to {txt_filename}")


if __name__ == "__main__":
    main()
