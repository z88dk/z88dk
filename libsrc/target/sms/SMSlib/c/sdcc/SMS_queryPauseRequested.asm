; unsigned char SMS_queryPauseRequested(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_queryPauseRequested

EXTERN asm_SMSlib_queryPauseRequested

defc _SMS_queryPauseRequested = asm_SMSlib_queryPauseRequested
