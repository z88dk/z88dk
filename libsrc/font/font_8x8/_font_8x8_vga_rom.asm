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
IF __CPU_GBZ80__
   INCLUDE "target/gb/fonts/lower.asm"
ENDIF

   BINARY "font_8x8_vga_rom.bin"

_font_8x8_vga_rom_end:
