
; sp1_DrawUpdateStructIfInv(struct sp1_update *u)

SECTION code_clib
SECTION code_temp_sp1

PUBLIC sp1_DrawUpdateStructIfInv

EXTERN asm_sp1_DrawUpdateStructIfInv

defc sp1_DrawUpdateStructIfInv = asm_sp1_DrawUpdateStructIfInv

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _sp1_DrawUpdateStructIfInv
defc _sp1_DrawUpdateStructIfInv = sp1_DrawUpdateStructIfInv
ENDIF

