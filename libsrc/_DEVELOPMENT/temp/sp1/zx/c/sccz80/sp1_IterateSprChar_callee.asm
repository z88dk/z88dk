; void __CALLEE__ sp1_IterateSprChar_callee(struct sp1_ss *s, void *hook1)
; 02.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateSprChar_callee

EXTERN asm_sp1_IterateSprChar

sp1_IterateSprChar_callee:

   pop hl
   pop ix
   ex (sp),hl

   jp asm_sp1_IterateSprChar
