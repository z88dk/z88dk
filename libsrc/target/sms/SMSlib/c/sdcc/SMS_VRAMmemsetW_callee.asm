; void SMS_VRAMmemsetW(unsigned int dst,unsigned int value,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC _SMS_VRAMmemsetW_callee

EXTERN asm_SMSlib_VRAMmemsetW

_SMS_VRAMmemsetW_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af

   jp asm_SMSlib_VRAMmemsetW
