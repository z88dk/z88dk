; void SMS_VRAMmemsetW(unsigned int dst,unsigned int value,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VRAMmemsetW

EXTERN asm_SMSlib_VRAMmemsetW

SMS_VRAMmemsetW:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp asm_SMSlib_VRAMmemsetW
