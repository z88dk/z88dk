; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_zeroSpritePalette

asm_SMSlib_zeroSpritePalette:

   ; void SMS_zeroSpritePalette (void)
   ;
   ; uses : af, b
   
   di
   
   ld a,+(SMS_CRAMAddress+0x10)&0xff
   out (VDPControlPort),a
   
   ld a,+(SMS_CRAMAddress+0x10)/256
   out (VDPControlPort),a
   
   ei
   
   xor a
   ld b,16

loop:

   out (VDPDataPort),a
   nop

   djnz loop
   ret
