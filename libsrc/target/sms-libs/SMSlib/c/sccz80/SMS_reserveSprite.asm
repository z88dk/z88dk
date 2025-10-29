; signed char SMS_reserveSprite(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_reserveSprite

EXTERN asm_SMSlib_reserveSprite

defc SMS_reserveSprite = asm_SMSlib_reserveSprite
