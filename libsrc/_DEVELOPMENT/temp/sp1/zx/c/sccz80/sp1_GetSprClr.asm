; void sp1_GetSprClr(uchar **sprsrc, struct sp1_ap *dest, uchar n)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_GetSprClr

EXTERN asm_sp1_GetSprClr

sp1_GetSprClr:

   pop af
   pop bc
   ld b,c
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   jp asm_sp1_GetSprClr
