; void SMS_setSpriteMode(unsigned char mode)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setSpriteMode

EXTERN asm_SMSlib_setSpriteMode

_SMS_setSpriteMode:

   pop af
	pop hl
	
	push hl
	push af
	
	jp asm_SMSlib_setSpriteMode
