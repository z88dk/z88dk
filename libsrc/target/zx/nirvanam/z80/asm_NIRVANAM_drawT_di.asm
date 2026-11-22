SECTION code_clib
SECTION code_nirvanam

PUBLIC asm_NIRVANAM_drawT_di

EXTERN asm_NIRVANAM_drawT

asm_NIRVANAM_drawT_di:

   di
	call asm_NIRVANAM_drawT
	ei
	ret
