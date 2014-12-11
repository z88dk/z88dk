
; int fzx_putc(uchar c)

SECTION code_font_fzx

PUBLIC fzx_putc

fzx_putc:

   ld a,l
   
   INCLUDE "font/fzx/zx/z80/asm_fzx_putc.asm"
