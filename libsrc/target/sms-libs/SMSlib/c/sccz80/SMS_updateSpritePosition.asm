; void SMS_updateSpritePosition(signed char sprite, unsigned char x, unsigned char y)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_updateSpritePosition

EXTERN asm_SMSlib_updateSpritePosition

SMS_updateSpritePosition:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   ld a,l
   jp asm_SMSlib_updateSpritePosition
