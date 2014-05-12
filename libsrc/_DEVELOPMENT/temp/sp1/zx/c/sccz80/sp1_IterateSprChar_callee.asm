; void __CALLEE__ sp1_IterateSprChar_callee(struct sp1_ss *s, void *hook1)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

PUBLIC sp1_IterateSprChar_callee

sp1_IterateSprChar_callee:

   pop hl
   pop ix
   ex (sp),hl

   INCLUDE "temp/sp1/zx/sprites/asm_sp1_IterateSprChar.asm"
