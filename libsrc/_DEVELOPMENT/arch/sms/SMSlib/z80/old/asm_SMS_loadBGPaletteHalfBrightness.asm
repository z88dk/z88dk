; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_loadBGPaletteHalfBrightness

include "../SMSlib_private.inc"

asm_SMS_loadBGPaletteHalfBrightness:

   ; void SMS_loadBGPaletteHalfBrightness (void *palette)
   ;
   ; enter : hl = void *palette
   ;
   ; uses  : af, b, hl
   
   di
   
   ld a,SMS_CRAMAddress&0xff
   out (VDPControlPort),a
   
   ld a,SMS_CRAMAddress/256
   out (VDPControlPort),a
   
   ei
   
   ld b,16

loop:

   ld a,(hl)
   inc hl
   
   rrca
   and 0x15
   
   out (VDPDataPort),a

   djnz loop
   ret
