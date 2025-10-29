; void SMS_waitForVBlank(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_waitForVBlank

EXTERN asm_SMSlib_waitForVBlank

defc SMS_waitForVBlank = asm_SMSlib_waitForVBlank
