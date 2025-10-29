
; sp1_UpdateNow

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_UpdateNow

EXTERN asm_sp1_UpdateNow

defc _sp1_UpdateNow = asm_sp1_UpdateNow
