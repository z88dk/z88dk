SECTION code_clib
SECTION code_nirvanap

PUBLIC asm_NIRVANAP_fillT_di

EXTERN asm_NIRVANAP_fillT

asm_NIRVANAP_fillT_di:

   di
	call asm_NIRVANAP_fillT
	ei
	ret
