import sys
from PIL import Image
import os


def main():
    if len(sys.argv) != 2:
        print("Usage: python png_to_txt.py <image.png>")
        sys.exit(1)

    png_filename = sys.argv[1]

    base, _ = os.path.splitext(png_filename)
    txt_filename = base + ".txt"

    img = Image.open(png_filename).convert("L")
    pixels = img.load()

    width, height = img.size

    with open(txt_filename, "w") as f:
        for y in range(height):
            for x in range(width):
                # Map 0–255 → -127–127
                signed_val = pixels[x, y] - 127

                # Clamp to ensure range is exactly -127..127
                if signed_val > 127:
                    signed_val = 127

                # Convert to 8-bit two's complement hex
                hex_val = signed_val & 0xFF
                f.write(f"{hex_val:02X}\n")

    print(f"Saved signed hex pixel data to {txt_filename}")


if __name__ == "__main__":
    main()
