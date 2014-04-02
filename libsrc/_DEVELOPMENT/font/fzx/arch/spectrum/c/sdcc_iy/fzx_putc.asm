
; int fzx_putc(uchar c)

XDEF _fzx_putc

_fzx_putc:

   pop af
   pop hl
   
   push hl
   push af

   ld a,l
   
   INCLUDE "font/fzx/arch/spectrum/z80/asm_fzx_putc.asm"
