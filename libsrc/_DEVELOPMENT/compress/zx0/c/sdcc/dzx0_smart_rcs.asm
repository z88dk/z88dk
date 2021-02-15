
; void dzx0_smart_rcs(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC _dzx0_smart_rcs

EXTERN asm_dzx0_smart_rcs

_dzx0_smart_rcs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx0_smart_rcs
