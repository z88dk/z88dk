; void sp1_GetSprClr(uchar **sprsrc, struct sp1_ap *dest, uchar n)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_GetSprClr_callee

EXTERN asm_sp1_GetSprClr

_sp1_GetSprClr_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   ld b,c
   jp asm_sp1_GetSprClr
