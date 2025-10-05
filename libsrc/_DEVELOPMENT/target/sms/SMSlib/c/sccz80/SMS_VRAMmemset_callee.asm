; void SMS_VRAMmemset(unsigned int dst,unsigned char value,unsigned int size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VRAMmemset_callee

EXTERN asm_SMSlib_VRAMmemset

SMS_VRAMmemset_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

   jp asm_SMSlib_VRAMmemset
