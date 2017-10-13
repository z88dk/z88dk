; void SMS_addTwoAdjoiningSprites(unsigned char x, unsigned char y, unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_addTwoAdjoiningSprites_callee

EXTERN asm_SMSlib_addTwoAdjoiningSprites

_SMS_addTwoAdjoiningSprites_callee:

   pop af
   pop de
   dec sp
   pop bc
   push af
   
   ld c,e
   jp asm_SMSlib_addTwoAdjoiningSprites
