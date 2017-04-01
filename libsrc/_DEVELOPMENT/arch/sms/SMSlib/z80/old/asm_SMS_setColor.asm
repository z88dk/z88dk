; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_setColor

include "../SMSlib_private.inc"

asm_SMS_setColor:

   ; void SMS_setColor (unsigned char color)
   ;
   ; enter :  l = unsigned char color
   ;
   ; uses  : a
   
   ld a,l
   out (VDPDataPort),a
   
   ret
