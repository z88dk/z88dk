; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_addTwoAdjoiningSprites

EXTERN __SMSlib_SpriteNextFree, __SMSlib_SpriteTableY, __SMSlib_SpriteTableXN
EXTERN __SMSlib_spritesWidth, __SMSlib_spritesTileOffset

asm_SMSlib_addTwoAdjoiningSprites:

   ; void SMS_addTwoAdjoiningSprites(unsigned char x, unsigned char y, unsigned char tile)
   ;
   ; enter :  c = unsigned char x
   ;          d = unsigned char y
   ;          b = unsigned char tile
   ;
   ; uses  : af, de, hl

   ld a,(__SMSlib_SpriteNextFree)
   
   cp MAXSPRITES - 1
   ret nc                      ; we do not have 2 sprites left, leave!
   
   ld e,a                      ; e = _SpriteNextFree
   
asm_SMSlib_addSprite_0:
   
   ld a,d                      ; a = unsigned char y
   
   cp 0xd1
   ret z                       ; invalid Y, leave!
   
   ld d,0                      ; de = _SpriteNextFree
   
   ld hl,__SMSlib_SpriteTableY
   add hl,de
   
   dec a
   ld (hl),a                   ; write Y  (as Y-1)
   inc hl
   ld (hl),a                   ; write Y again for the second sprite (always as Y-1)

   ld hl,__SMSlib_SpriteTableXN
   add hl,de
   add hl,de
   
   ld (hl),c                   ; write X
   inc hl
   ld (hl),b                   ; write tile number
   
   ld a,(__SMSlib_spritesWidth)  ; a = current sprite width

   add a,c
   jr c, secondSpriteClipped   ; if new X is overflowing, do not place second sprite

   inc hl
   ld (hl),a                   ; write X + spritesWidth
   
   ld a,(__SMSlib_spritesTileOffset)  ; a = current sprite tile offset
   add a,b

   inc hl
   ld (hl),a                   ; write tile number + spritesTileOffset
   
   ld a,e

   add a,2
   ld (__SMSlib_SpriteNextFree),a

   ret

secondSpriteClipped:

   ld hl,__SMSlib_SpriteNextFree
   inc (hl)
   
   ret
