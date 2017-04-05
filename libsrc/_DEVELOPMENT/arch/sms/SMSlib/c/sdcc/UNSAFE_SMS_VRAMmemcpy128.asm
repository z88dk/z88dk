; void UNSAFE_SMS_VRAMmemcpy128(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _UNSAFE_SMS_VRAMmemcpy128

EXTERN asm_SMSlib_VRAMmemcpy128

_UNSAFE_SMS_VRAMmemcpy128:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af

   jp asm_SMSlib_VRAMmemcpy128
