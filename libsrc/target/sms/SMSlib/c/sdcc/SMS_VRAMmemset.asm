; void SMS_VRAMmemset(unsigned int dst,unsigned char value,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VRAMmemset

EXTERN asm_SMSlib_VRAMmemset

_SMS_VRAMmemset:

   pop af
   pop hl
   dec sp
   pop de
   pop bc
   
   push bc
   push de
   inc sp
   push hl
   push af
   
   ld e,d
   jp asm_SMSlib_VRAMmemset
