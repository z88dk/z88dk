
; int fzx_setat(uchar y, uchar x)

XDEF fzx_setat_callee

fzx_setat_callee:

   pop af
   pop hl
   pop de
   push af
   
   ld h,e
   
   INCLUDE "font/fzx/arch/spectrum/z80/asm_fzx_setat.asm"
