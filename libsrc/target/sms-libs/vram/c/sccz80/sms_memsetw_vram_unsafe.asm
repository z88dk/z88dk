; void *sms_memsetw_vram_unsafe(void *dst, unsigned int c, unsigned int n)

SECTION code_clib
SECTION code_arch

PUBLIC sms_memsetw_vram_unsafe

EXTERN asm_sms_memsetw_vram_unsafe

sms_memsetw_vram_unsafe:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_sms_memsetw_vram_unsafe
