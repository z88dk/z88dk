; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_loadSpritePalette

asm_SMSlib_loadSpritePalette:

   ; void SMS_loadSpritePalette (void *palette)
   ;
   ; enter : hl = void *palette
   ;
   ; uses  : af, bc, hl
   
   di 
   
   ld a,+(SMS_CRAMAddress+0x10)&0xff
   out (VDPControlPort),a
   
   ld a,+(SMS_CRAMAddress+0x10)/256
   out (VDPControlPort),a
   
   ei
   
   ld bc,0x1000 + VDPDataPort

loop:

   outi
   jr nz, loop
   
   ret
