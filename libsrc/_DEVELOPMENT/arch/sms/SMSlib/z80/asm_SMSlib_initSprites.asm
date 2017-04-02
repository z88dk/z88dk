; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

INCLUDE "SMSlib_private.inc"

SECTION code_clib
SECTION code_SMSlib

PUBLIC asm_SMSlib_initSprites

EXTERN _SpriteNextFree

asm_SMSlib_initSprites:

   ; void SMS_initSprites (void)
   ;
   ; uses  : af
   
   xor a
   ld (_SpriteNextFree),a
   
   ret
