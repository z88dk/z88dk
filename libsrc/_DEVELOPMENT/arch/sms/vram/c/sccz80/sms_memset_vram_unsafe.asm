; void *sms_memset_vram(void *dst, unsigned char c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC _sms_memset_vram_unsafe

EXTERN asm_sms_memset_vram_unsafe

_sms_memset_vram_unsafe:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   ld a,l
   jp asm_sms_memset_vram_unsafe
