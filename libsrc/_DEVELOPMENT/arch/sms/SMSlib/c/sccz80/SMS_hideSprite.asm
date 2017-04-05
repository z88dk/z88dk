; void SMS_hideSprite(unsigned char sprite)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_hideSprite

EXTERN asm_SMSlib_hideSprite

defc _SMS_hideSprite = asm_SMSlib_hideSprite
