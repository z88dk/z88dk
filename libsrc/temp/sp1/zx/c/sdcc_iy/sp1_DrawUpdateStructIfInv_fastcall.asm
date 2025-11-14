
; sp1_DrawUpdateStructIfInv(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructIfInv_fastcall

EXTERN asm_sp1_DrawUpdateStructIfInv

defc _sp1_DrawUpdateStructIfInv_fastcall = asm_sp1_DrawUpdateStructIfInv
