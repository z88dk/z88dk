; void SMS_finalizeSprites(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_finalizeSprites

EXTERN asm_SMSlib_finalizeSprites

defc _SMS_finalizeSprites = asm_SMSlib_finalizeSprites
