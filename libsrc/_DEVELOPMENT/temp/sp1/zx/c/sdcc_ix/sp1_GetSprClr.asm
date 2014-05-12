; void sp1_GetSprClr(uchar **sprsrc, struct sp1_ap *dest, uchar n)

PUBLIC _sp1_GetSprClr

_sp1_GetSprClr:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld b,c

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_GetSprClr.asm"
