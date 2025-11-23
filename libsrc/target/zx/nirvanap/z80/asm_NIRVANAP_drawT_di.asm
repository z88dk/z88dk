SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_drawT_di

EXTERN asm_NIRVANAP_drawT

asm_NIRVANAP_drawT_di:

   di
	call asm_NIRVANAP_drawT
	ei
	ret
