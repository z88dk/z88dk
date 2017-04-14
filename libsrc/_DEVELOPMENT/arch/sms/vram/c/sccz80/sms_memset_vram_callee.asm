; void *sms_memset_vram(void *dst, unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memset_vram_callee

EXTERN asm_sms_memset_vram

_sms_memset_vram_callee:

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ld a,l
   jp asm_sms_memset_vram
