; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_useFirstHalfTilesforSprites

asm_SMSlib_useFirstHalfTilesforSprites:

   ; void SMS_useFirstHalfTilesforSprites (_Bool usefirsthalf)
   ;
   ; enter :  l = _Bool usefirsthalf
   ;
   ; uses  : af
   
   inc l
   dec l
   
   ld a,0xff
   jr z, cont
   
   ld a,0xfb

cont:
   
	di
	
   out (VDPControlPort),a
   
   ld a,0x86
   out (VDPControlPort),a
   
   ei
   ret
