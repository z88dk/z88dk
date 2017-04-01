; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_queryPauseRequested

EXTERN _PauseRequested

asm_SMSlib_queryPauseRequested:

   ; unsigned int SMS_queryPauseRequested (void)
   ;
   ; exit : hl = 1 if paused else 0
   ;
   ; uses : hl
   
   ld hl,(_PauseRequested)
	ld h,0
   
   ret
