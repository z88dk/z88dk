; unsigned int sms_cxy2saddr(unsigned char x, unsigned char y)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_cxy2saddr_callee

EXTERN asm_sms_cxy2saddr

_sms_cxy2saddr_callee:

   pop hl
   ex (sp),hl
   
   jp asm_sms_cxy2saddr
