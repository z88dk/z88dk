SECTION rodata_font
SECTION rodata_font_8x8

PUBLIC _font_8x8_coleco_adam_system
PUBLIC _font_6x8_coleco_adam_system
PUBLIC _font_8x8_coleco_adam_system_end

_font_8x8_coleco_adam_system:
_font_6x8_coleco_adam_system:
IF __CPU_GBZ80__
   INCLUDE "target/gb/fonts/lower.asm"
ENDIF

   BINARY "font_8x8_coleco_adam_system.bin"

_font_8x8_coleco_adam_system_end:
