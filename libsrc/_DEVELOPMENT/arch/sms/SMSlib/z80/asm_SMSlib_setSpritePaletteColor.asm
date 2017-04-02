; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_setSpritePaletteColor

asm_SMSlib_setSpritePaletteColor:

   ; void SMS_setSpritePaletteColor (unsigned char entry, unsigned char color)
   ;
   ; enter :  l = unsigned char entry
   ;          a = unsigned char color
   ;
   ; uses  : af, bc, hl
   
   ld h,0
   ld bc,0xc010
   add hl,bc
   
   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)

   out (VDPDataPort),a
   ret
