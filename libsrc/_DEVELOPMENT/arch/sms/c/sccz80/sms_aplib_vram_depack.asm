
; void sms_aplib_vram_depack(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC sms_aplib_vram_depack

EXTERN asm_sms_aplib_vram_depack

sms_aplib_vram_depack:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_sms_aplib_vram_depack
