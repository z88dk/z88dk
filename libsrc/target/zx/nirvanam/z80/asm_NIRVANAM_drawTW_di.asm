SECTION code_clib
SECTION code_nirvanam

PUBLIC asm_NIRVANAM_drawTW_di

EXTERN asm_NIRVANAM_drawTW

asm_NIRVANAM_drawTW_di:

   di
	call asm_NIRVANAM_drawTW
	ei
	ret
