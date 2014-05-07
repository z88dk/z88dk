; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

XDEF _sp1_GetSprClrAddr

_sp1_GetSprClrAddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_GetSprClrAddr.asm"
