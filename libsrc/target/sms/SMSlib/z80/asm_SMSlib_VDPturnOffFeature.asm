; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_VDPturnOffFeature

EXTERN __SMSlib_VDPReg

asm_SMSlib_VDPturnOffFeature:

   ; void SMS_VDPturnOffFeature (unsigned int feature)
   ;
   ; enter : hl = unsigned int feature
   ;
   ; uses  : af, de, hl
   
   ex de,hl
   
   ld hl,__SMSlib_VDPReg
   
   inc d
   dec d
   jr z, noinc
   
   inc hl

noinc:
   
   ld a,e
   cpl
   and (hl)
   ld (hl),a
   
   di
   
   out (VDPControlPort),a
   
   ld a,d
   or 0x80
   
   out (VDPControlPort),a
   
   ei
   ret
