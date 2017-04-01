; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_reserveSprite

EXTERN error_mc
EXTERN _SpriteNextFree, _SpriteTableY

include "../SMSlib_private.inc"

asm_SMS_reserveSprite:

   ; int SMS_reserveSprite (void)
   ;
   ; exit : success
   ;
   ;           hl = sprite #
   ;           carry reset
   ;
   ;        fail
   ;
   ;           hl = -1
   ;           carry set
   ;
   ; uses : af, de, hl
   
   ld a,(_SpriteNextFree)
   
   cp MAXSPRITES
   jp nc, error_mc
   
   ld e,a
   ld d,0
   
   ld hl,_SpriteTableY
   add hl,de
   
   ld (hl),0xe0
   
   inc a
   ld (_SpriteNextFree),a
   
   ex de,hl
   ret
