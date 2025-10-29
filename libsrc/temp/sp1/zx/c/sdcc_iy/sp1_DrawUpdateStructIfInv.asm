
; sp1_DrawUpdateStructIfInv(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfInv

EXTERN asm_sp1_DrawUpdateStructIfInv

_sp1_DrawUpdateStructIfInv:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sp1_DrawUpdateStructIfInv
