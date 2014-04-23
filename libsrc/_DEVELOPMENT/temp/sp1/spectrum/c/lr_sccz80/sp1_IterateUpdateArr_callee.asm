; void __CALLEE__ sp1_IterateUpdateArr_callee(struct sp1_update **ua, void *hook)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

XDEF sp1_IterateUpdateArr_callee

sp1_IterateUpdateArr_callee:

   pop hl
   pop ix
   ex (sp),hl

   INCLUDE "temp/sp1/spectrum/updater/asm_sp1_IterateUpdateArr.asm"
