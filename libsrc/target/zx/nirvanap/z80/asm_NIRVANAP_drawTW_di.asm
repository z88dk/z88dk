SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_drawTW_di

EXTERN asm_NIRVANAP_drawTW

asm_NIRVANAP_drawTW_di:

   di
	call asm_NIRVANAP_drawTW
	ei
	ret
