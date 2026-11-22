; void SMS_setBGScrollY(unsigned char scrollY)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_setBGScrollY_fastcall

EXTERN asm_SMSlib_setBGScrollY

defc _SMS_setBGScrollY_fastcall = asm_SMSlib_setBGScrollY
