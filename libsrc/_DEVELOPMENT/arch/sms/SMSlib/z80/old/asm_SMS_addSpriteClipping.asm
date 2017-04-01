; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_addSpriteClipping

EXTERN error_mc, error_zc
EXTERN asm_SMS_addSprite_0, _clipWin_x0, _clipWin_x1
EXTERN _SpriteNextFree, _spritesWidth, _spritesHeight

include "../SMSlib_private.inc"

asm_SMS_addSpriteClipping:

   ; int SMS_addSpriteClipping (int x, int y, unsigned char tile)
   ;
   ; enter :  b = unsigned char tile
   ;          c = unsigned char x
   ;          d = unsigned char y
   ; 
   ; exit  : success
   ;
   ;            hl = sprite #
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = -1 (too many sprites), 0 (clipped)
   ;            carry set
   ;
   ; uses  : af, de, hl
   
   ld a,(_SpriteNextFree)
   
   cp MAXSPRITES
   jp nc, error_mc
   
   ld e,a
   
   ld hl,(_clipWin_x1)         ; l = x1, h = y1
   
   ld a,c
   cp l
   
   jr z, ok00
   jp nc, error_zc             ; if x > x1
   
ok00:

   ld a,d
   cp h
   
   jr z, ok01
   jp nc, error_zc             ; if y > y1

ok01:

   ld hl,(_clipWin_x0)         ; l = x0, h = y0
   
   ld a,(_spritesWidth)
   add a,c
   
   jr c, ok02
   
   cp l
   jp c, error_zc              ; if x < x0 - width
   
ok02:

   ld a,(_spritesHeight)
   add a,d
   
   jp c, asm_SMS_addSprite_0
   
   cp h
   jp nc, asm_SMS_addSprite_0
   
   jp error_zc                 ; if y < y0 - height
