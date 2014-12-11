; void __CALLEE__ sp1_GetSprClrAddr_callee(struct sp1_ss *s, uchar **sprdest)

SECTION code_temp_sp1

PUBLIC sp1_GetSprClrAddr_callee

sp1_GetSprClrAddr_callee:

   pop hl
   pop de
   ex (sp),hl

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_GetSprClrAddr.asm"
