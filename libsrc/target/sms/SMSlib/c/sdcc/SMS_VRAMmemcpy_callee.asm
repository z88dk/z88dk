; void SMS_VRAMmemcpy(unsigned int dst,void *src,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VRAMmemcpy_callee

EXTERN asm_SMSlib_VRAMmemcpy

_SMS_VRAMmemcpy_callee:

   pop af
	pop hl
	pop de
	pop bc
	push af

   jp asm_SMSlib_VRAMmemcpy
