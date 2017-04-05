; void UNSAFE_SMS_VRAMmemcpy128(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC UNSAFE_SMS_VRAMmemcpy128_callee

EXTERN asm_SMSlib_VRAMmemcpy128

UNSAFE_SMS_VRAMmemcpy128_callee:

   pop hl
	pop de
	ex (sp),hl

   jp asm_SMSlib_VRAMmemcpy128
