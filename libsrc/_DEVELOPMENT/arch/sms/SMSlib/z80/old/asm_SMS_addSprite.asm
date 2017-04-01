; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_addSprite, asm_SMS_addSprite_0

EXTERN error_mc
EXTERN _SpriteNextFree, _Sprite_TableY, _SpriteTableXN

include "../SMSlib_private.inc"

asm_SMS_addSprite:

   ; int SMS_addSprite (unsigned char x, unsigned char y, unsigned char tile)
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
   ;            hl = -1
   ;            carry set
   ;
   ; uses  : af, de, hl
   
   ld a,(_SpriteNextFree)
   
   cp MAXSPRITES
   jp nc, error_mc
   
   ld e,a
   
asm_SMS_addSprite_0:
   
   ld a,d                      ; a = unsigned char y
   
   cp 0xd1
   jp z, error_mc
   
   ld d,0                      ; de = _SpriteNextFree
   
   ld hl,_SpriteTableY
   add hl,de
   
   dec a
   ld (hl),a                   ; SpriteTableY[SpriteNextFree]=(unsigned char)(y-1)
   
   ld hl,_SpriteTableXN
   add hl,de
   add hl,de
   
   ld (hl),c                   ; SpriteTableXN[SpriteNextFree*2]=x
   inc hl
   ld (hl),b                   ; SpriteTableXN[SpriteNextFree*2+1]=tile
   
   ld a,e
   inc a
   ld (_SpriteNextFree),a
   
   ex de,hl
   ret
