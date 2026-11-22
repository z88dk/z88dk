; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_initSprites

EXTERN __SMSlib_SpriteNextFree

asm_SMSlib_initSprites:

   ; void SMS_initSprites (void)
   ;
   ; uses  : af
   
   xor a
   ld (__SMSlib_SpriteNextFree),a
   
   ret
