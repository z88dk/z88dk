SECTION rodata_font
SECTION rodata_font_8x8

PUBLIC _font_8x8_msx_system
PUBLIC _font_8x8_msx_system_end

_font_8x8_msx_system:
IF __CPU_GBZ80__
   INCLUDE "target/gb/fonts/lower.asm"
ENDIF

   BINARY "font_8x8_msx_system.bin"

_font_8x8_msx_system_end:
