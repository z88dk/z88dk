; void __CALLEE__ sp1_IterateUpdateArr_callee(struct sp1_update **ua, void *hook)
; 03.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_IterateUpdateArr_callee

EXTERN asm_sp1_IterateUpdateArr

sp1_IterateUpdateArr_callee:

   pop hl
   pop ix
   ex (sp),hl

   jp asm_sp1_IterateUpdateArr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_IterateUpdateArr_callee
defc _sp1_IterateUpdateArr_callee = sp1_IterateUpdateArr_callee
ENDIF

