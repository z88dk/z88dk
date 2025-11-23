
; sp1_DrawUpdateStructAlways(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC _sp1_DrawUpdateStructAlways_fastcall

EXTERN asm_sp1_DrawUpdateStructAlways

defc _sp1_DrawUpdateStructAlways_fastcall = asm_sp1_DrawUpdateStructAlways
