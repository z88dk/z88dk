; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_getMDKeysHeld

EXTERN __SMSlib_MDKeysStatus, __SMSlib_PreviousMDKeysStatus

asm_SMSlib_getMDKeysHeld:

   ; unsigned int SMS_getMDKeysHeld (void)
   ;
   ; exit : hl = MD keys held
   ;
   ; uses : af, hl

   ld hl,(__SMSlib_MDKeysStatus)
   
   ld a,(__SMSlib_PreviousMDKeysStatus)
   and l
   ld l,a
   
   ld a,(__SMSlib_PreviousMDKeysStatus+1)
   and h
   ld h,a
   
   ret
