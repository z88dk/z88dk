; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_updateSpritePosition

EXTERN _SpriteTableY, _SpriteTableXN

include "../SMSlib_private.inc"

asm_SMS_updateSpritePosition:

   ; void SMS_updateSpritePosition (unsigned int sprite, unsigned char x, unsigned char y)
   ;
   ; enter : de = unsigned int sprite
   ;          a = unsigned char y
   ;          c = unsigned char x
   ;
   ; uses : af, hl

   ld hl,_SpriteTableY
   add hl,de
   
   cp 0xd1
   jr z, bad_sprite_coord
   
   dec a
   ld (hl),a
   
   ld hl,_SpriteTableXN
   add hl,de
   add hl,de
   
   ld (hl),c
   ret

bad_sprite_coord:

   ld (hl),0xe0
   ret
