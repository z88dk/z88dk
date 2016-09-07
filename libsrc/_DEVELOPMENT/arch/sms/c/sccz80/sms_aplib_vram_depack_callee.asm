
; void sms_aplib_vram_depack_callee(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC sms_aplib_vram_depack_callee

EXTERN asm_sms_aplib_vram_depack

sms_aplib_vram_depack_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_sms_aplib_vram_depack
