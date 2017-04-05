; void SMS_loadPSGaidencompressedTiles(void *src, unsigned int tilefrom)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_loadPSGaidencompressedTiles

EXTERN SMS_loadPSGaidencompressedTiles_callee_0

SMS_loadPSGaidencompressedTiles:

   pop af
	pop hl
	pop de
	
	push de
	push hl
	push af

   jp SMS_loadPSGaidencompressedTiles_callee_0
