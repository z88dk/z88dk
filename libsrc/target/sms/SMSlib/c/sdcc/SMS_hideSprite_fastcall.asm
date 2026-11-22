; void SMS_hideSprite(unsigned char sprite)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_hideSprite_fastcall

EXTERN asm_SMSlib_hideSprite

defc _SMS_hideSprite_fastcall = asm_SMSlib_hideSprite
