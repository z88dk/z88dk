
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfNotRem

EXTERN asm_sp1_DrawUpdateStructIfNotRem

_sp1_DrawUpdateStructIfNotRem:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_DrawUpdateStructIfNotRem
