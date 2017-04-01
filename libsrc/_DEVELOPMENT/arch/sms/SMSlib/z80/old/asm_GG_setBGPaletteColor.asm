; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_GG_setBGPaletteColor

include "../SMSlib_private.inc"

asm_GG_setBGPaletteColor:

   ; void GG_setBGPaletteColor (unsigned char entry, unsigned int color)
   ;
   ; enter :  l = unsigned char entry
   ;         de = unsigned int color
   ;
   ; uses  : af, bc, de, hl
   
   ;; SMS_setAddr(0xC000+(entry*2))
   
   ld h,0
   add hl,hl
   
   ld bc,0xc000
   add hl,bc
   
   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)
   
   ;; SMS_setTile(color)
   
   ex de,hl
   jp SMS_crt0_RST18
