; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_VDPType

EXTERN _VDPType

asm_SMSlib_VDPType:

	; unsigned char SMS_VDPType (void)
	;
	; exit : l = vdp type
	;
	; uses : hl
	
	ld hl,(_VDPType)
	ret
