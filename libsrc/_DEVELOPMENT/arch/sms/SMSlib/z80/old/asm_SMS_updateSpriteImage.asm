; **************************************************
; SMSlib - C programming library for the SMS/GG
; ( part of devkitSMS - github.com/sverx/devkitSMS )
; **************************************************

SECTION code_lib
PUBLIC asm_SMS_updateSpriteImage

EXTERN _SpriteTableXN

asm_SMS_updateSpriteImage:

   ; void SMS_updateSpriteImage (unsigned int sprite, unsigned char image)
   ;
   ; enter : de = unsigned int sprite
   ;          a = unsigned char image
   ;
   ; uses : f, hl

   ld hl,_SpriteTableXN
   add hl,de
   add hl,de
   
   inc hl
   ld (hl),a
   
   ret
