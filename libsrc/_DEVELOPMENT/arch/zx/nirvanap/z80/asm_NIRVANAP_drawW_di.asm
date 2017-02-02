SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_drawW_di

EXTERN asm_NIRVANAP_drawW

asm_NIRVANAP_drawW_di:

   di
	call asm_NIRVANAP_drawW
	ei
	ret
