; void SMS_copySpritestoSAT(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_copySpritestoSAT

EXTERN asm_SMSlib_copySpritestoSAT

defc SMS_copySpritestoSAT = asm_SMSlib_copySpritestoSAT
