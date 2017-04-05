; void UNSAFE_SMS_VRAMmemcpy64(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _UNSAFE_SMS_VRAMmemcpy64_callee

EXTERN asm_SMSlib_VRAMmemcpy64

_UNSAFE_SMS_VRAMmemcpy64_callee:

   pop af
   pop hl
   pop de
   push af

   jp asm_SMSlib_VRAMmemcpy64
