; void UNSAFE_SMS_VRAMmemcpy32(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _UNSAFE_SMS_VRAMmemcpy32_callee

EXTERN asm_SMSlib_VRAMmemcpy32

_UNSAFE_SMS_VRAMmemcpy32_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_SMSlib_VRAMmemcpy32
