; void SMS_VRAMmemset(unsigned int dst,unsigned char value,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VRAMmemset

EXTERN asm_SMSlib_VRAMmemset

SMS_VRAMmemset:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp asm_SMSlib_VRAMmemset
