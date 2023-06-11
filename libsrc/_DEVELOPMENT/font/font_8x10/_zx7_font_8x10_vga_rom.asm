;
; VGA ROM font, modified to ZX code page
;
; Extracted from: https://www.min.at/prinz/o/software/pixelfont/
;

SECTION rodata_font
SECTION rodata_font_8x10

PUBLIC  _zx7_font_8x10_vga_rom
PUBLIC  _zx7_font_8x10_vga_rom_end


_zx7_font_8x10_vga_rom:

   BINARY "font_8x10_vga_rom.bin.zx7"

_zx7_font_8x10_vga_rom_end:
