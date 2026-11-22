; void SMS_VDPturnOnFeature(unsigned int feature)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VDPturnOnFeature

EXTERN asm_SMSlib_VDPturnOnFeature

_SMS_VDPturnOnFeature:

   pop af
	pop hl
	
	push hl
	push af
	
	jp asm_SMSlib_VDPturnOnFeature
