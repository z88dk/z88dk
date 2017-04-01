; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_zeroBGPalette

include "../SMSlib_private.inc"

asm_SMS_zeroBGPalette:

   ; void SMS_zeroBGPalette (void)
   ;
   ; uses : af, b
   
   di
   
   ld a,SMS_CRAMAddress&0xff
   out (VDPControlPort),a
   
   ld a,SMS_CRAMAddress/256
   out (VDPControlPort),a
   
   ei
   
   xor a
   ld b,16

loop:

   out (VDPControlPort),a
   nop

   djnz loop
   ret
