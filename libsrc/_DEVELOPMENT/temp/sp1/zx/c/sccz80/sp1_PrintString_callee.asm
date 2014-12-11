; void __CALLEE__ sp1_PrintString_callee(struct sp1_pss *ps, uchar *s)
; 02.2008 aralbrec, Sprite Pack v3.0
; zxz81 hi-res version

SECTION code_temp_sp1

PUBLIC sp1_PrintString_callee

sp1_PrintString_callee:

   pop hl
   pop de
   ex (sp),hl

   INCLUDE "temp/sp1/zx/tiles/asm_sp1_PrintString.asm"
