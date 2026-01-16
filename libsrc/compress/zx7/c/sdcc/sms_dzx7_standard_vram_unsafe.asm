
; unsigned int sms_dzx7_standard_vram(void *src, unsigned int dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC _sms_dzx7_standard_vram_unsafe

EXTERN asm_sms_dzx7_standard_vram_unsafe

_sms_dzx7_standard_vram_unsafe:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_sms_dzx7_standard_vram_unsafe
