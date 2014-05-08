
; sp1_DrawUpdateStructIfVal(struct sp1_update *u)

PUBLIC _sp1_DrawUpdateStructIfVal

_sp1_DrawUpdateStructIfVal:

   pop af
   pop hl
   
   push hl
   push af

   push ix
   
   call asm_sp1_DrawUpdateStructIfVal
   
   pop ix
   ret
   
   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_DrawUpdateStructIfVal.asm"
