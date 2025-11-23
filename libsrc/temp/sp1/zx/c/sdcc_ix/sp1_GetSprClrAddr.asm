; void sp1_GetSprClrAddr(struct sp1_ss *s, uchar **sprdest)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_GetSprClrAddr

EXTERN l0_sp1_GetSprClrAddr_callee

_sp1_GetSprClrAddr:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp l0_sp1_GetSprClrAddr_callee
