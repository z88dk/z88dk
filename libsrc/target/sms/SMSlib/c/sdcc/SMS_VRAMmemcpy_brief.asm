; void SMS_VRAMmemcpy_brief(unsigned int dst,void *src,unsigned char size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VRAMmemcpy_brief

EXTERN asm_SMSlib_VRAMmemcpy_brief

_SMS_VRAMmemcpy_brief:

   pop af
   pop hl
   pop de
   pop bc
   
   push bc
   push de
   push hl
   push af

   ld b,c
   jp asm_SMSlib_VRAMmemcpy_brief
