; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_setBGScrollX

include "../SMSlib_private.inc"

asm_SMS_setBGScrollX:

   ; void SMS_setBGScrollX (unsigned char scrollX)
   ;
   ; enter :  l = unsigned char scrollX
   ;
   ; uses  : af
   
   di
   
   ld a,l
   out (VDPControlPort),a
   
   ld a,0x88
   out (VDPControlPort),a
   
   ei
   ret
