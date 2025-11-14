; void SMS_addTwoAdjoiningSprites(unsigned char x, unsigned char y, unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMSlib_addTwoAdjoiningSprites

EXTERN asm_SMSlib_addTwoAdjoiningSprites

_SMSlib_addTwoAdjoiningSprites:

   pop af
   pop de
   pop bc
   
   push bc
   push de
   push af
   
   ld b,c
   ld c,e
   
   jp asm_SMSlib_addTwoAdjoiningSprites
