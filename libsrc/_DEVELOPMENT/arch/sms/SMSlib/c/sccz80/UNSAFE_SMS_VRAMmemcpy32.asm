; void UNSAFE_SMS_VRAMmemcpy32(unsigned int dst,void *src)

SECTION code_clib
SECTION code_SMSlib

PUBLIC UNSAFE_SMS_VRAMmemcpy32

EXTERN asm_SMSlib_VRAMmemcpy32

UNSAFE_SMS_VRAMmemcpy32:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af

   jp asm_SMSlib_VRAMmemcpy32
