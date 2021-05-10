import fire


class Convert():

    def hex_to_rgb(self, hex: str):
        h = hex.lstrip("#")
        rgb = []
        for i in (0, 2, 4):
            rgb = rgb.append((int(h[i:i+2], 16)))
        print(tuple(rgb))

    def rgb_to_hex(self, rgb: str):
        return '%02x%02x%02x' % rgb
        rgb_to_hex((255, 255, 195))


if __name__ == "__main__":
    fire.Fire(Convert)
