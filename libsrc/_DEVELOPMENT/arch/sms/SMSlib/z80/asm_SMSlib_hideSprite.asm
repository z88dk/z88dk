; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_hideSprite

EXTERN _SpriteTableY

asm_SMSlib_hideSprite:

   ; void SMS_hideSprite (signed char sprite)
   ;
   ; enter : l = signed char sprite
   ;
   ; uses : de, hl

   ld h,0
   
   ld de,_SpriteTableY
   add hl,de
   
   ld (hl),0xe0
   ret
