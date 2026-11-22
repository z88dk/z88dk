; void sp1_PutSprClr(uchar **sprdest, struct sp1_ap *src, uchar n)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_PutSprClr

EXTERN asm_sp1_PutSprClr

_sp1_PutSprClr:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld b,c
   jp asm_sp1_PutSprClr
