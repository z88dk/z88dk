; unsigned char SMS_VDPType(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VDPType

EXTERN asm_SMSlib_VDPType

defc _SMS_VDPType = asm_SMSlib_VDPType
