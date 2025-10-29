; void SMS_addTwoAdjoiningSprites(unsigned char x, unsigned char y, unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_addTwoAdjoiningSprites

EXTERN asm_SMSlib_addTwoAdjoiningSprites

SMS_addTwoAdjoiningSprites:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld b,l
   ld d,e
   
   jp asm_SMSlib_addTwoAdjoiningSprites
