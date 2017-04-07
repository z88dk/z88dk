; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_updateSpritePosition

EXTERN __SMSlib_SpriteTableY, __SMSlib_SpriteTableXN

asm_SMSlib_updateSpritePosition:

   ; void SMS_updateSpritePosition (signed char sprite, unsigned char x, unsigned char y)
   ;
   ; enter :  e = signed char sprite
   ;          a = unsigned char y
   ;          c = unsigned char x
   ;
   ; uses : af, d, hl

   ld d,0
   
   ld hl,__SMSlib_SpriteTableY
   add hl,de
   
   cp 0xd1
   jr z, bad_sprite_coord
   
   dec a
   ld (hl),a
   
   ld hl,__SMSlib_SpriteTableXN
   add hl,de
   add hl,de
   
   ld (hl),c
   ret

bad_sprite_coord:

   ld (hl),0xe0
   ret
