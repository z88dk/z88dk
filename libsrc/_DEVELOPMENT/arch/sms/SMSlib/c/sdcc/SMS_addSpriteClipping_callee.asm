; signed char SMS_addSpriteClipping(int x,int y,unsigned char tile)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_addSpriteClipping_callee

EXTERN asm_SMSlib_addSpriteClipping

_SMS_addSpriteClipping_callee:

   pop hl
   pop bc
   pop de
   dec sp
   ex (sp),hl

   jp asm_SMSlib_addSpriteClipping
