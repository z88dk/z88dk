; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_initSprites

EXTERN _SpriteNextFree

asm_SMS_initSprites:

   ; void SMS_initSprites (void)
   ;
   ; uses  : af
   
   xor a
   ld (_SpriteNextFree),a
   
   ret
