; void SMS_VRAMmemcpy(unsigned int dst,void *src,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VRAMmemcpy

EXTERN asm_SMSlib_VRAMmemcpy

_SMS_VRAMmemcpy:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   jp asm_SMSlib_VRAMmemcpy
