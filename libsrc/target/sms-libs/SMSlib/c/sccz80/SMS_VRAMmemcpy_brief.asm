; void SMS_VRAMmemcpy_brief(unsigned int dst,void *src,unsigned char size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VRAMmemcpy_brief

EXTERN asm_SMSlib_VRAMmemcpy_brief

SMS_VRAMmemcpy_brief:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   ld b,c
   jp asm_SMSlib_VRAMmemcpy_brief
