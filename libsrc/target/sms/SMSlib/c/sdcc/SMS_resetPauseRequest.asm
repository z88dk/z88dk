; void SMS_resetPauseRequest(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_resetPauseRequest

EXTERN asm_SMSlib_resetPauseRequest

defc _SMS_resetPauseRequest = asm_SMSlib_resetPauseRequest
