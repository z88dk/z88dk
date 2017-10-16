; void SMS_addTwoAdjoiningSprites(unsigned char x, unsigned char y, unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMSlib_addTwoAdjoiningSprites_callee

EXTERN asm_SMSlib_addTwoAdjoiningSprites

SMSlib_addTwoAdjoiningSprites_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   ld b,l
   ld d,e
   jp asm_SMSlib_addTwoAdjoiningSprites
