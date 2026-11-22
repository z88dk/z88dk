; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_hideSprite

EXTERN __SMSlib_SpriteTableY

asm_SMSlib_hideSprite:

   ; void SMS_hideSprite (signed char sprite)
   ;
   ; enter : l = signed char sprite
   ;
   ; uses : f, de, hl

   ld h,0
   
   ld de,__SMSlib_SpriteTableY
   add hl,de
   
   ld (hl),0xe0
   ret
