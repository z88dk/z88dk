; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC SMS_useFirstHalfTilesforSprites

include "../SMSlib_private.inc"

SMS_useFirstHalfTilesforSprites:

   ; void SMS_useFirstHalfTilesforSprites (_Bool usefirsthalf)
   ;
   ; enter :  l = _Bool usefirsthalf
   ;
   ; uses  : af
   
   di
   
   inc l
   dec l
   
   ld a,0xff
   jr z, cont
   
   ld a,0xfb

cont:
   
   out (VDPControlPort),a
   
   ld a,0x86
   out (VDPControlPort),a
   
   ei
   ret
