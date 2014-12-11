
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)

SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfNotRem

_sp1_DrawUpdateStructIfNotRem:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_sp1_DrawUpdateStructIfNotRem
   
   push ix
   ret

   INCLUDE "temp/sp1/zx/updater/asm_sp1_DrawUpdateStructIfNotRem.asm"
