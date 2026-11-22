; void SMS_updateSpritePosition(signed char sprite, unsigned char x, unsigned char y)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_updateSpritePosition

EXTERN asm_SMSlib_updateSpritePosition

_SMS_updateSpritePosition:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   ld c,d
   ld a,l

   jp asm_SMSlib_updateSpritePosition
