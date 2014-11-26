; void sp1_PutSprClr(uchar **sprdest, struct sp1_ap *src, uchar n)

SECTION seg_code_sp1

PUBLIC _sp1_PutSprClr

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

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_PutSprClr.asm"
