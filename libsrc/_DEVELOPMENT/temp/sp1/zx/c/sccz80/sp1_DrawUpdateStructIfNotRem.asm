
; sp1_DrawUpdateStructIfNotRem(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DrawUpdateStructIfNotRem

EXTERN asm_sp1_DrawUpdateStructIfNotRem

defc sp1_DrawUpdateStructIfNotRem = asm_sp1_DrawUpdateStructIfNotRem
