; signed char SMS_reserveSprite(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_reserveSprite

EXTERN asm_SMSlib_reserveSprite

defc _SMS_reserveSprite = asm_SMSlib_reserveSprite
