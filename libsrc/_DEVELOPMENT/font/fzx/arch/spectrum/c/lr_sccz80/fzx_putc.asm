
; int fzx_putc(uchar c)

XDEF fzx_putc

fzx_putc:

   ld a,l
   
   INCLUDE "font/fzx/arch/spectrum/z80/asm_fzx_putc.asm"
