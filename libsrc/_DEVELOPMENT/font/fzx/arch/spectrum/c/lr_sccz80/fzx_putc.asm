
; int fzx_putc(uchar c)

XDEF fzx_putc

fzx_putc:

   ld a,l
   
   INCLUDE "../../z80/asm_fzx_putc.asm"
