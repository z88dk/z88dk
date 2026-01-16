; signed char SMS_addSpriteClipping(int x,int y,unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_addSpriteClipping

EXTERN asm_SMSlib_addSpriteClipping

_SMS_addSpriteClipping:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   ld h,l
   jp asm_SMSlib_addSpriteClipping
