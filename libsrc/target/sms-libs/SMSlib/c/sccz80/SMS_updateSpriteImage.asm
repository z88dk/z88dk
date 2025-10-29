; void SMS_updateSpriteImage(signed char sprite, unsigned char image)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_updateSpriteImage

EXTERN asm_SMSlib_updateSpriteImage

SMS_updateSpriteImage:

   pop af
   pop bc
   pop de
   
   push de
   push bc
   push af
   
   ld a,c
   jp asm_SMSlib_updateSpriteImage
