; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_getVCount

asm_SMSlib_getVCount:

   ; unsigned char SMS_getVCount (void)
   ;
   ; uses  : af, l
   
   in a,(VDPVCounterPort)
   ld l,a
   ret
