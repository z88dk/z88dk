; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setBGScrollX

asm_SMSlib_setBGScrollX:

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
