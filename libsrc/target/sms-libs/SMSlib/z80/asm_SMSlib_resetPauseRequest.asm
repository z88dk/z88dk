; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_resetPauseRequest

EXTERN __SMSlib_PauseRequested

asm_SMSlib_resetPauseRequest:

   ; void SMS_resetPauseRequest (void)
   ;
   ; uses : af
   
   xor a
	ld (__SMSlib_PauseRequested),a
	
   ret
