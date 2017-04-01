; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_setLineCounter

include "../SMSlib_private.inc"

asm_SMS_setLineCounter:

   ; void SMS_setLineCounter (unsigned char count)
   ;
   ; enter :  l = unsigned char count
   ;
   ; uses  : a
   
   di
   
   ld a,l
   out (VDPControlPort),a
   
   ld a,0x8a
   out (VDPControlPort),a
   
   ei
   ret
