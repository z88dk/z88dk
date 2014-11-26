; void __CALLEE__ sp1_GetSprClr_callee(uchar **sprsrc, struct sp1_ap *dest, uchar n)

SECTION seg_code_sp1

PUBLIC sp1_GetSprClr_callee

sp1_GetSprClr_callee:

   pop hl
   pop bc
   ld b,c
   pop de
   ex (sp),hl

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_GetSprClr.asm"
