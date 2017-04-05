; void SMS_loadPSGaidencompressedTiles(void *src, unsigned int tilefrom)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_loadPSGaidencompressedTiles

EXTERN _SMS_loadPSGaidencompressedTiles_callee_0

_SMS_loadPSGaidencompressedTiles:

   pop af
	pop hl
	pop de
	
	push de
	push hl
	push af

   jp _SMS_loadPSGaidencompressedTiles_callee_0
