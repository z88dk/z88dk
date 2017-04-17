; unsigned int sms_cxy2saddr(unsigned char x, unsigned char y)

SECTION code_clib
SECTION code_arch

PUBLIC sms_cxy2saddr_callee

EXTERN asm_sms_cxy2saddr

sms_cxy2saddr_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   ld h,c
   jp asm_sms_cxy2saddr
