; void SMS_VDPturnOnFeature(unsigned int feature)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VDPturnOnFeature

EXTERN asm_SMSlib_VDPturnOnFeature

defc SMS_VDPturnOnFeature = asm_SMSlib_VDPturnOnFeature
