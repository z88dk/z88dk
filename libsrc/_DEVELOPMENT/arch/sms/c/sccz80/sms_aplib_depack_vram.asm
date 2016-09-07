
; void sms_aplib_depack_vram(void *dst, void *src)

SECTION code_clib
SECTION code_compress_aplib

PUBLIC sms_aplib_depack_vram

EXTERN asm_sms_aplib_depack_vram

sms_aplib_depack_vram:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_sms_aplib_depack_vram
