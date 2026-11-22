; unsigned int sms_cxy2saddr(unsigned char x, unsigned char y)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_cxy2saddr

EXTERN asm_sms_cxy2saddr

_sms_cxy2saddr:

   pop af
   pop hl
   
   push hl
   push af

   jp asm_sms_cxy2saddr
