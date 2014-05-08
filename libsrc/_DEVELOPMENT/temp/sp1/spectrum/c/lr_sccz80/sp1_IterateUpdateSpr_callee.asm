; void __CALLEE__ sp1_IterateUpdateSpr_callee(struct sp1_ss *s, void *hook2)
; 11.2006 aralbrec, Sprite Pack v3.0
; sinclair spectrum version

PUBLIC sp1_IterateUpdateSpr_callee

sp1_IterateUpdateSpr_callee:

   pop hl
   pop ix
   ex (sp),hl

   INCLUDE "temp/sp1/spectrum/sprites/asm_sp1_IterateUpdateSpr.asm"
