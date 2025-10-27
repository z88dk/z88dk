; void SMS_finalizeSprites(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_finalizeSprites

EXTERN asm_SMSlib_finalizeSprites

defc SMS_finalizeSprites = asm_SMSlib_finalizeSprites
