
; void __FASTCALL__ sp1_DeleteSpr(struct sp1_ss *s)

XDEF _sp1_DeleteSpr

_sp1_DeleteSpr:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_DeleteSpr.asm"
