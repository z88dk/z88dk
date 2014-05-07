
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)

XDEF _sp1_DrawUpdateStructIfNotRem

_sp1_DrawUpdateStructIfNotRem:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_sp1_DrawUpdateStructIfNotRem
   
   push ix
   ret

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_DrawUpdateStructIfNotRem.asm"
