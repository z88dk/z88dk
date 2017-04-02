;; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setBackdropColor

asm_SMSlib_setBackdropColor:

   ; void SMS_setBackdropColor (unsigned char entry)
   ;
   ; enter :  l = unsigned char entry
   ;
   ; uses  : af
   
   di
   
   ld a,l
   out (VDPControlPort),a
   
   ld a,0x87
   out (VDPControlPort),a
   
   ei
   ret
