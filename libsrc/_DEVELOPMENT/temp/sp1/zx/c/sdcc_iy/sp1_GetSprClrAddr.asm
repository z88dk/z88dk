; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

PUBLIC _sp1_GetSprClrAddr

_sp1_GetSprClrAddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_GetSprClrAddr.asm"
