; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

PUBLIC _sp1_GetSprClrAddr

_sp1_GetSprClrAddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   push ix
   
   call asm_sp1_GetSprClrAddr
   
   pop ix
   ret

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_GetSprClrAddr.asm"
