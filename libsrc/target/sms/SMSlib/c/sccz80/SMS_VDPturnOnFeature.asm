; void SMS_VDPturnOnFeature(unsigned int feature)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VDPturnOnFeature

EXTERN asm_SMSlib_VDPturnOnFeature

defc SMS_VDPturnOnFeature = asm_SMSlib_VDPturnOnFeature

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _SMS_VDPturnOnFeature
defc _SMS_VDPturnOnFeature = SMS_VDPturnOnFeature
ENDIF

