; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_queryPauseRequested

EXTERN __SMSlib_PauseRequested

asm_SMSlib_queryPauseRequested:

   ; unsigned char SMS_queryPauseRequested (void)
   ;
   ; exit : l = 1 if paused else 0
   ;
   ; uses : hl
   
   ld hl,(__SMSlib_PauseRequested)
   ret
