; void SMS_VDPturnOnFeature(unsigned int feature)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VDPturnOnFeature

EXTERN asm_SMSlib_VDPturnOnFeature

defc _SMS_VDPturnOnFeature = asm_SMSlib_VDPturnOnFeature
