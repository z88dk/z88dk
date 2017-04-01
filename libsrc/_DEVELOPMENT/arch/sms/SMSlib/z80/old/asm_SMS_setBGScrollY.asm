; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_setBGScrollY

include "../SMSlib_private.inc"

asm_SMS_setBGScrollY:

   ; void SMS_setBGScrollY (unsigned char scrollY)
   ;
   ; enter :  l = unsigned char scrollY
   ;
   ; uses  : af
   
   di
   
   ld a,l
   out (VDPControlPort),a
   
   ld a,0x89
   out (VDPControlPort),a
   
   ei
   ret
