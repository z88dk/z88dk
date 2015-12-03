
; sp1_DrawUpdateStructAlways(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DrawUpdateStructAlways

EXTERN asm_sp1_DrawUpdateStructAlways

defc sp1_DrawUpdateStructAlways = asm_sp1_DrawUpdateStructAlways
