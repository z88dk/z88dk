; signed char SMS_addSprite(unsigned char x,unsigned char y,unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_addSprite

EXTERN asm_SMSlib_addSprite

_SMS_addSprite:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   ld b,c
   ld c,e
   
   jp asm_SMSlib_addSprite
