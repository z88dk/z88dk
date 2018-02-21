;
; VGA ROM font, modified to ZX code page
;
; Extracted from: https://www.min.at/prinz/o/software/pixelfont/
;

SECTION rodata_font
SECTION rodata_font_8x8

PUBLIC  _font_8x8_vga_rom
PUBLIC  _font_8x8_vga_rom_end

_font_8x8_vga_rom:

   BINARY "../font/font_8x8/_font_8x8_VGAROM.fon"

_font_8x8_vga_rom_end:
