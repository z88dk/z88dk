; void SMS_loadPSGaidencompressedTiles(void *src, unsigned int tilefrom)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadPSGaidencompressedTiles_callee
PUBLIC _SMS_loadPSGaidencompressedTiles_callee_0

EXTERN asm_SMSlib_loadPSGaidencompressedTiles

_SMS_loadPSGaidencompressedTiles_callee:

	pop hl
	pop de
	ex (sp),hl

_SMS_loadPSGaidencompressedTiles_callee_0:

	push ix
	push iy
	
	call asm_SMSlib_loadPSGaidencompressedTiles

	pop iy
	pop ix
	
	ret
