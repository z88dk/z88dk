; void SMS_waitForVBlank(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_waitForVBlank

EXTERN asm_SMSlib_waitForVBlank

defc _SMS_waitForVBlank = asm_SMSlib_waitForVBlank
