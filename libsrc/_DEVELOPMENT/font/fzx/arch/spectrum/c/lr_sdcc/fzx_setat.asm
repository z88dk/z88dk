
; int fzx_setat(uchar y, uchar x)

XDEF fzx_setat

fzx_setat:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   ld h,e
   
   INCLUDE "font/fzx/arch/spectrum/z80/asm_fzx_setat.asm"
