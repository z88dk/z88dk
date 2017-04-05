; void SMS_hideSprite(unsigned char sprite)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_hideSprite

EXTERN asm_SMSlib_hideSprite

defc SMS_hideSprite = asm_SMSlib_hideSprite
