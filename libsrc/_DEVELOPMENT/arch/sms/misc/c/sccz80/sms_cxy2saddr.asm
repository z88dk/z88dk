; unsigned int sms_cxy2saddr(unsigned char x, unsigned char y)

SECTION code_clib
SECTION code_arch

PUBLIC sms_cxy2saddr

EXTERN asm_sms_cxy2saddr

sms_cxy2saddr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   ld h,c
   jp asm_sms_cxy2saddr
