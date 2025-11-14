
; sp1_DrawUpdateStructAlways(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructAlways

EXTERN asm_sp1_DrawUpdateStructAlways

_sp1_DrawUpdateStructAlways:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_DrawUpdateStructAlways
