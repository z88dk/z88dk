; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_GetSprClrAddr_callee, l0_sp1_GetSprClrAddr_callee

EXTERN asm_sp1_GetSprClrAddr

_sp1_GetSprClrAddr:

   pop af
   pop hl
   pop de
   push af

l0_sp1_GetSprClrAddr_callee:

   push ix
   
   call asm_sp1_GetSprClrAddr
   
   pop ix
   ret
