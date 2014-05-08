; void __CALLEE__ sp1_GetSprClrAddr_callee(struct sp1_ss *s, uchar **sprdest)

PUBLIC sp1_GetSprClrAddr_callee

sp1_GetSprClrAddr_callee:

   pop hl
   pop de
   ex (sp),hl

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_GetSprClrAddr.asm"
