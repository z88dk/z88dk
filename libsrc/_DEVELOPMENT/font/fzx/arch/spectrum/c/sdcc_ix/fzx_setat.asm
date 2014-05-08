
; int fzx_setat(uchar y, uchar x)

PUBLIC _fzx_setat

_fzx_setat:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   
   INCLUDE "font/fzx/arch/spectrum/z80/asm_fzx_setat.asm"
