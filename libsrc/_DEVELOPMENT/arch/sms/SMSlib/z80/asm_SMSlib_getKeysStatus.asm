; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_getKeysStatus

EXTERN __SMSlib_KeysStatus

asm_SMSlib_getKeysStatus:

   ; unsigned int SMS_getKeysStatus (void)
   ;
   ; exit : hl = (_KeysStatus)
   ;
   ; uses : hl

   ld hl,(__SMSlib_KeysStatus)
   ret
