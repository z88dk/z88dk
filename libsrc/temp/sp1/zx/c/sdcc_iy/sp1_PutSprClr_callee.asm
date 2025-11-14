; void sp1_PutSprClr(uchar **sprdest, struct sp1_ap *src, uchar n)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PutSprClr_callee

EXTERN asm_sp1_PutSprClr

_sp1_PutSprClr_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   ld b,c
   jp asm_sp1_PutSprClr
