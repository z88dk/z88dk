; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_getHCount

include "../SMSlib_private.inc"

asm_SMS_getHCount:

   ; unsigned char SMS_getHCount (void)
   ;
   ; uses  : a, l
   
   in a,(VDPHCounterPort)
   ld l,a
   ret
