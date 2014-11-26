
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)

SECTION seg_code_sp1

PUBLIC _sp1_DrawUpdateStructIfNotRem

_sp1_DrawUpdateStructIfNotRem:

   pop af
   pop hl
   
   push hl
   push af

   INCLUDE "temp/sp1/zx/updater/asm_sp1_DrawUpdateStructIfNotRem.asm"
