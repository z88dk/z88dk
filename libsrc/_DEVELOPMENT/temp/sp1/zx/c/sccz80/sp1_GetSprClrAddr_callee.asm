; void __CALLEE__ sp1_GetSprClrAddr_callee(struct sp1_ss *s, uchar **sprdest)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_GetSprClrAddr_callee

EXTERN asm_sp1_GetSprClrAddr

sp1_GetSprClrAddr_callee:

   pop hl
   pop de
   ex (sp),hl

   jp asm_sp1_GetSprClrAddr
