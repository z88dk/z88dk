; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setColor

asm_SMSlib_setColor:

   ; void SMS_setColor (unsigned char color)
   ;
   ; enter :  l = unsigned char color
   ;
   ; uses  : a
   
   ld a,l
   out (VDPDataPort),a
   
   ret
