SECTION code_clib
SECTION code_nirvanam

PUBLIC asm_NIRVANAM_drawW_di

EXTERN asm_NIRVANAM_drawW

asm_NIRVANAM_drawW_di:

   di
	call asm_NIRVANAM_drawW
	ei
	ret
