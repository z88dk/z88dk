; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_setSpritePaletteColor

include "../SMSlib_private.inc"

asm_SMS_setSpritePaletteColor:

   ; void SMS_setSpritePaletteColor (unsigned char entry, unsigned int color)
   ;
   ; enter :  l = unsigned char entry
   ;         de = unsigned int color
   ;
   ; uses  : af, bc, de, hl
   
   ;; SMS_setAddr(0xC000+(entry*2))
   
   ld h,0
   add hl,hl
   
   ld bc,0xc010
   add hl,bc
   
   rst SMS_crt0_RST08          ; SMS_crt0_RST08(hl)
   
   ;; SMS_byte_to_VDP_data(color)
   
   ld a,e
   out (VDPDataPort),a
   
   ret
