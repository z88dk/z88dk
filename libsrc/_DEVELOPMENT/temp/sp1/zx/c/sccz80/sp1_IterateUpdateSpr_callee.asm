; void __CALLEE__ sp1_IterateUpdateSpr_callee(struct sp1_ss *s, void *hook2)
; 11.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateUpdateSpr_callee

EXTERN asm_sp1_IterateUpdateSpr

sp1_IterateUpdateSpr_callee:

   pop hl
   pop ix
   ex (sp),hl

   jp asm_sp1_IterateUpdateSpr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_IterateUpdateSpr_callee
defc _sp1_IterateUpdateSpr_callee = sp1_IterateUpdateSpr_callee
ENDIF

