
; void sms_aplib_depack_vram(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC _sms_aplib_depack_vram

EXTERN asm_sms_aplib_depack_vram

_sms_aplib_depack_vram:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_sms_aplib_depack_vram
