
; int fzx_setat(uchar y, uchar x)

XDEF fzx_setat

fzx_setat:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld h,e
   
   INCLUDE "../../z80/asm_fzx_setat.asm"
