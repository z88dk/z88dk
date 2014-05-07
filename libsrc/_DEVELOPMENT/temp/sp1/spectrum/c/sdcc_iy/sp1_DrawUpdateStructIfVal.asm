
; sp1_DrawUpdateStructIfVal(struct sp1_update *u)

XDEF _sp1_DrawUpdateStructIfVal

_sp1_DrawUpdateStructIfVal:

   pop af
   pop hl
   
   push hl
   push af
   
   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_DrawUpdateStructIfVal.asm"
