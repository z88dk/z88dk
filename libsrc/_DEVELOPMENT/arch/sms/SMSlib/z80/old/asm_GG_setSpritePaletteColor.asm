; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_GG_setSpritePaletteColor

include "../SMSlib_private.inc"

asm_GG_setSpritePaletteColor:

   ; void GG_setSpritePaletteColor (unsigned char entry, unsigned int color)
   ;
   ; enter :  l = unsigned char entry
   ;         de = unsigned int color
   ;
   ; uses  : af, bc, de, hl
   
   ;; SMS_setAddr(0xC020+(entry*2))
   
   ld h,0
   add hl,hl
   
   ld bc,0xc020
   add hl,bc
   
   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)
   
   ;; SMS_setTile(color)
   
   ex de,hl
   jp SMS_crt0_RST18
