; void UNSAFE_SMS_VRAMmemcpy64(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC UNSAFE_SMS_VRAMmemcpy64_callee

EXTERN asm_SMSlib_VRAMmemcpy64

UNSAFE_SMS_VRAMmemcpy64_callee:

   pop hl
	pop de
	ex (sp),hl

   jp asm_SMSlib_VRAMmemcpy64
