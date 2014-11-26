
; sp1_DrawUpdateStructAlways(struct sp1_update *u)

SECTION seg_code_sp1

PUBLIC _sp1_DrawUpdateStructAlways

_sp1_DrawUpdateStructAlways:

   pop af
   pop hl
   
   push hl
   push af
   
   push ix
   
   call asm_sp1_DrawUpdateStructAlways
   
   pop ix
   ret

   INCLUDE "temp/sp1/zx/updater/asm_sp1_DrawUpdateStructAlways.asm"
