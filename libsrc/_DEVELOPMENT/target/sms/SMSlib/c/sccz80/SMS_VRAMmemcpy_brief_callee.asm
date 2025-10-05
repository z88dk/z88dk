; void SMS_VRAMmemcpy_brief(unsigned int dst,void *src,unsigned char size)

SECTION code_clib
SECTION code_SMSlib

PUBLIC SMS_VRAMmemcpy_brief_callee

EXTERN asm_SMSlib_VRAMmemcpy_brief

SMS_VRAMmemcpy_brief_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   
   ld b,c
   jp asm_SMSlib_VRAMmemcpy_brief
