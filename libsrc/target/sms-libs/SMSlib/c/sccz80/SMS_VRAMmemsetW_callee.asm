; void SMS_VRAMmemsetW(unsigned int dst,unsigned int value,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VRAMmemsetW_callee

EXTERN asm_SMSlib_VRAMmemsetW

SMS_VRAMmemsetW_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

   jp asm_SMSlib_VRAMmemsetW
