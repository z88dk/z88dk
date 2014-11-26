; void __CALLEE__ sp1_IterateUpdateArr_callee(struct sp1_update **ua, void *hook)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION seg_code_sp1

PUBLIC sp1_IterateUpdateArr_callee

sp1_IterateUpdateArr_callee:

   pop hl
   pop ix
   ex (sp),hl

   INCLUDE "temp/sp1/zx/updater/asm_sp1_IterateUpdateArr.asm"
