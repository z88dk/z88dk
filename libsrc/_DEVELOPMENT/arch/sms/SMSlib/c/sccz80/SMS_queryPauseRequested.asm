; unsigned char SMS_queryPauseRequested(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_queryPauseRequested

EXTERN asm_SMSlib_queryPauseRequested

defc SMS_queryPauseRequested = asm_SMSlib_queryPauseRequested
