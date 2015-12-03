
; sp1_UpdateNow
; 01.2006 aralbrec, Sprite Pack v3.0
; sinclair zx version

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_UpdateNow

EXTERN asm_sp1_UpdateNow

defc sp1_UpdateNow = asm_sp1_UpdateNow
