; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setBGScrollY

asm_SMSlib_setBGScrollY:

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
