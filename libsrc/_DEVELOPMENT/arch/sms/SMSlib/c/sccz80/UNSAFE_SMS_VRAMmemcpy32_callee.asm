; void UNSAFE_SMS_VRAMmemcpy32(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC UNSAFE_SMS_VRAMmemcpy32_callee

EXTERN asm_SMSlib_VRAMmemcpy32

UNSAFE_SMS_VRAMmemcpy32_callee:

   pop hl
	pop de
	ex (sp),hl

   jp asm_SMSlib_VRAMmemcpy32
