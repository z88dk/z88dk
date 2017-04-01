; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_zeroSpritePalette

include "../SMSlib_private.inc"

asm_SMS_zeroSpritePalette:

   ; void SMS_zeroSpritePalette (void)
   ;
   ; uses : af, b
   
   di
   
   ld a,#(SMS_CRAMAddress+0x10)&0xff
   out (VDPControlPort),a
   
   ld a,#(SMS_CRAMAddress+0x10)/256
   out (VDPControlPort),a
   
   ei
   
   xor a
   ld b,16

loop:

   out (VDPControlPort),a
   nop

   djnz loop
   ret
