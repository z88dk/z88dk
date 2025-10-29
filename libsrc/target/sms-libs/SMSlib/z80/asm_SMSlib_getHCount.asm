; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_getHCount

asm_SMSlib_getHCount:

   ; unsigned char SMS_getHCount (void)
   ;
   ; uses  : af, l
   
   in a,(VDPHCounterPort)
   ld l,a
   ret
