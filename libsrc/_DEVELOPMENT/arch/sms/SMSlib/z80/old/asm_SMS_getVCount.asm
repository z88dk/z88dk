; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_getVCount

include "../SMSlib_private.inc"

asm_SMS_getVCount:

   ; unsigned char SMS_getVCount (void)
   ;
   ; uses  : a, l
   
   in a,(VDPVCounterPort)
   ld l,a
   ret
