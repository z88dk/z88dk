; void SMS_loadTiles(void *src, unsigned int tilefrom, unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadTiles_callee

EXTERN asm_SMSlib_loadTiles

_SMS_loadTiles_callee:

	pop af
	pop de
	pop hl
	pop bc
	push af
	
	jp asm_SMSlib_loadTiles
