; void SMS_VDPturnOffFeature(unsigned int feature)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VDPturnOffFeature

EXTERN asm_SMSlib_VDPturnOffFeature

_SMS_VDPturnOffFeature:

   pop af
	pop hl
	
	push hl
	push af
	
	jp asm_SMSlib_VDPturnOffFeature
