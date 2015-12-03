
; sp1_DrawUpdateStructIfVal(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DrawUpdateStructIfVal

EXTERN asm_sp1_DrawUpdateStructIfVal

defc sp1_DrawUpdateStructIfVal = asm_sp1_DrawUpdateStructIfVal
