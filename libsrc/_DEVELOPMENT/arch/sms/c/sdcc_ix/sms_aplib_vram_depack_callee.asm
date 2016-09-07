
; void sms_aplib_vram_depack_callee(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC _sms_aplib_vram_depack_callee

EXTERN asm_sms_aplib_vram_depack

_sms_aplib_vram_depack_callee:

   pop hl
   pop de
   ex (sp),hl
   
   jp asm_sms_aplib_vram_depack
