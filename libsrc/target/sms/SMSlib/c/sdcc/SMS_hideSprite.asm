; void SMS_hideSprite(unsigned char sprite)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_hideSprite

EXTERN asm_SMSlib_hideSprite

_SMS_hideSprite:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_SMSlib_hideSprite
