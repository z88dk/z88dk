; void SMS_updateSpriteImage(signed char sprite, unsigned char image)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_updateSpriteImage

EXTERN asm_SMSlib_updateSpriteImage

_SMS_updateSpriteImage:

   pop af
   pop de
   
   push de
   push af
   
   ld a,d
   jp asm_SMSlib_updateSpriteImage
