; signed char SMS_addSprite(unsigned char x,unsigned char y,unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_addSprite_callee

EXTERN asm_SMSlib_addSprite

_SMS_addSprite_callee:

   pop af
   pop de
   dec sp
   pop bc
   push af
   
   ld c,e
   jp asm_SMSlib_addSprite
