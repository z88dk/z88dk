; void SMS_VRAMmemset(unsigned int dst,unsigned char value,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VRAMmemset_callee

EXTERN asm_SMSlib_VRAMmemset

_SMS_VRAMmemset_callee:

   pop af
	pop hl
	dec sp
	pop de
	pop bc
	push af
	
	ld e,d
   jp asm_SMSlib_VRAMmemset
