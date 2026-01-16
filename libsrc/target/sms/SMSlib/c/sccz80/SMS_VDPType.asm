; unsigned char SMS_VDPType(void)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VDPType

EXTERN asm_SMSlib_VDPType

defc SMS_VDPType = asm_SMSlib_VDPType

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_VDPType
defc _SMS_VDPType = SMS_VDPType
ENDIF

