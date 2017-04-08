
; void sms_aplib_depack_vram_callee(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC sms_aplib_depack_vram_callee

EXTERN asm_sms_aplib_depack_vram

sms_aplib_depack_vram_callee:

   pop af
   pop hl
   pop de
   push af
   
   jp asm_sms_aplib_depack_vram
