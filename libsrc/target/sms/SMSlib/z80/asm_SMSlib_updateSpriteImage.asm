; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_updateSpriteImage

EXTERN __SMSlib_SpriteTableXN

asm_SMSlib_updateSpriteImage:

   ; void SMS_updateSpriteImage (signed char sprite, unsigned char image)
   ;
   ; enter :  e = signed char sprite
   ;          a = unsigned char image
   ;
   ; uses : f, d, hl

   ld d,0
   
   ld hl,__SMSlib_SpriteTableXN
   add hl,de
   add hl,de
   
   inc hl
   ld (hl),a
   
   ret
