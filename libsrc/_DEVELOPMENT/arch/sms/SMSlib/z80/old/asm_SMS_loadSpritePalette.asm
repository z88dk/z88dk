; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_loadSpritePalette

include "../SMSlib_private.inc"

asm_SMS_loadSpritePalette:

   ; void SMS_loadSpritePalette (void *palette)
   ;
   ; enter : hl = void *palette
   ;
   ; uses  : af, bc, hl
   
   di 
   
   ld a,#(SMS_CRAMAddress+0x10)&0xff
   out (VDPControlPort),a
   
   ld a,#(SMS_CRAMAddress+0x10)/256
   out (VDPControlPort),a
   
   ei
   
   ld bc,0x1000 + VDPControlPort

loop:

   outi
   jr nz, loop
   
   ret
