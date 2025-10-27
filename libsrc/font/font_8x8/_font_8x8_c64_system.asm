;
; Commodore 64 font, modified to ZX code page
;
; Extracted from: https://www.min.at/prinz/o/software/pixelfont/
;

SECTION rodata_font
SECTION rodata_font_8x8

PUBLIC  _font_8x8_c64_system
PUBLIC  _font_8x8_c64_system_end

_font_8x8_c64_system:
IF __CPU_GBZ80__
   INCLUDE "target/gb/fonts/lower.asm"
ENDIF

   BINARY "font_8x8_c64_system.bin"

_font_8x8_c64_system_end:
