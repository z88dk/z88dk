; void SMS_VRAMmemcpy_brief(unsigned int dst,void *src,unsigned char size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VRAMmemcpy_brief_callee

EXTERN asm_SMSlib_VRAMmemcpy_brief

_SMS_VRAMmemcpy_brief_callee:

   pop af
	pop hl
	pop de
   dec sp
	pop bc
	push af

   jp asm_SMSlib_VRAMmemcpy_brief
