; void SMS_init(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_init

EXTERN asm_SMSlib_init

defc _SMS_init = asm_SMSlib_init
