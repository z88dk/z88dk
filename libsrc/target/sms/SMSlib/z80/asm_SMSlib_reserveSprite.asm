; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_reserveSprite

EXTERN error_mc
EXTERN __SMSlib_SpriteNextFree, __SMSlib_SpriteTableY

asm_SMSlib_reserveSprite:

   ; signed char SMS_reserveSprite (void)
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
   
   ld a,(__SMSlib_SpriteNextFree)
   
   cp MAXSPRITES
   jp nc, error_mc
   
   ld e,a
   ld d,0
   
   ld hl,__SMSlib_SpriteTableY
   add hl,de
   
   ld (hl),0xe0
   
   inc a
   ld (__SMSlib_SpriteNextFree),a
   
   ex de,hl
   ret
