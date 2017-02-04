SECTION code_clib
SECTION code_nirvanam

PUBLIC asm_NIRVANAM_fillT_di

EXTERN asm_NIRVANAM_fillT

asm_NIRVANAM_fillT_di:

   di
	call asm_NIRVANAM_fillT
	ei
	ret
