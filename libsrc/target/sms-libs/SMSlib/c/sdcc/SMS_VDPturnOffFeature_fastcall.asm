; void SMS_VDPturnOffFeature(unsigned int feature)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VDPturnOffFeature_fastcall

EXTERN asm_SMSlib_VDPturnOffFeature

defc _SMS_VDPturnOffFeature_fastcall = asm_SMSlib_VDPturnOffFeature
