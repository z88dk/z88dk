
; sp1_DrawUpdateStructIfInv(struct sp1_update *u)

SECTION seg_code_sp1

PUBLIC _sp1_DrawUpdateStructIfInv

_sp1_DrawUpdateStructIfInv:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/zx/updater/asm_sp1_DrawUpdateStructIfInv.asm"
