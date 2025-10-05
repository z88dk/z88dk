; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_getMDKeysStatus

EXTERN __SMSlib_MDKeysStatus

asm_SMSlib_getMDKeysStatus:

   ; unsigned int SMS_getMDKeysStatus (void)
   ;
   ; exit : hl = (_MDKeysStatus)
   ;
   ; uses : hl

   ld hl,(__SMSlib_MDKeysStatus)
   ret
