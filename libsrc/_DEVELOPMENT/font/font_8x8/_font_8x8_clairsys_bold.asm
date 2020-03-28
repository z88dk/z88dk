SECTION rodata_font
SECTION rodata_font_8x8

PUBLIC _font_8x8_clairsys_bold
PUBLIC _font_8x8_clairsys_bold_end

_font_8x8_clairsys_bold:
IF __CPU_GBZ80__
   INCLUDE "target/gb/fonts/lower.asm"
ENDIF

   BINARY "font_8x8_clairsys_bold.bin"

_font_8x8_clairsys_bold_end:
