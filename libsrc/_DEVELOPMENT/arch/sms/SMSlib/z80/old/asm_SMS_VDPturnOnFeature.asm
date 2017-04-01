; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_VDPturnOnFeature

EXTERN _VDPReg

include "../SMSlib_private.inc"

asm_SMS_VDPturnOnFeature:

   ; void SMS_VDPturnOnFeature (unsigned int feature)
   ;
   ; enter : hl = unsigned int feature
   ;
   ; uses  : af, de, hl
   
   ex de,hl
   
   ld hl,_VDPReg
   
   inc d
   dec d
   jr z, noinc
   
   inc hl

noinc:
   
   ld a,e
   or (hl)
   ld (hl),a
   
   di
   
   out (VDPControlPort),a
   
   ld a,d
   or 0x80
   
   out (VDPControlPort),a
   
   ei
   ret
