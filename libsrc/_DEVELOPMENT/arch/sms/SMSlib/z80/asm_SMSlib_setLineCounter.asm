; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setLineCounter

asm_SMSlib_setLineCounter:

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
