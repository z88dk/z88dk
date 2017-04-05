; void SMS_updateSpritePosition(signed char sprite, unsigned char x, unsigned char y)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_updateSpritePosition_callee

EXTERN asm_SMSlib_updateSpritePosition

SMS_updateSpritePosition_callee:

   pop hl
   pop bc
   ld a,c
   pop bc
   ex (sp),hl
   
   ld e,l
   jp asm_SMSlib_updateSpritePosition
