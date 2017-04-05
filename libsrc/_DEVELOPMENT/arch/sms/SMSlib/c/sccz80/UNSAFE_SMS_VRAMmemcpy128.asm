; void UNSAFE_SMS_VRAMmemcpy128(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC UNSAFE_SMS_VRAMmemcpy128

EXTERN asm_SMSlib_VRAMmemcpy128

UNSAFE_SMS_VRAMmemcpy128:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_SMSlib_VRAMmemcpy128
