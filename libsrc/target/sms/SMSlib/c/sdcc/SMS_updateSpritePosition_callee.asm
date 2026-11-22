; void SMS_updateSpritePosition(signed char sprite, unsigned char x, unsigned char y)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_updateSpritePosition_callee

EXTERN asm_SMSlib_updateSpritePosition

_SMS_updateSpritePosition_callee:

   pop hl
   pop de
   ld c,d
   dec sp
   ex (sp),hl
   ld a,h
   
   jp asm_SMSlib_updateSpritePosition
