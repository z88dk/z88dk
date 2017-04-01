; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_setBackdropColor

include "../SMSlib_private.inc"

asm_SMS_setBackdropColor:

   ; void SMS_setBackdropColor (unsigned char entry)
   ;
   ; enter :  l = unsigned char scrollX
   ;
   ; uses  : af
   
   di
   
   ld a,l
   out (VDPControlPort),a
   
   ld a,0x87
   out (VDPControlPort),a
   
   ei
   ret
