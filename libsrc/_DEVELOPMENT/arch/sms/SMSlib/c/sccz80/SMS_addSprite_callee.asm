; signed char SMS_addSprite(unsigned char x,unsigned char y,unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_addSprite_callee

EXTERN asm_SMSlib_addSprite

SMS_addSprite_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   ld b,l
   ld d,e
   jp asm_SMSlib_addSprite
