
; unsigned int sms_dzx7_standard_vram_unsafe(void *src, unsigned int dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC sms_dzx7_standard_vram_unsafe

EXTERN asm_sms_dzx7_standard_vram_unsafe

sms_dzx7_standard_vram_unsafe:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_sms_dzx7_standard_vram_unsafe
