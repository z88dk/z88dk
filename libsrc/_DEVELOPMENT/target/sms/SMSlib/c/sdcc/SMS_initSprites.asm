; void SMS_initSprites(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_initSprites

EXTERN asm_SMSlib_initSprites

defc _SMS_initSprites = asm_SMSlib_initSprites
