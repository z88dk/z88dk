; signed char SMS_addSpriteClipping(int x,int y,unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_addSpriteClipping

EXTERN asm_SMSlib_addSpriteClipping

SMS_addSpriteClipping:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af
   
   ld h,l
   jp asm_SMSlib_addSpriteClipping
