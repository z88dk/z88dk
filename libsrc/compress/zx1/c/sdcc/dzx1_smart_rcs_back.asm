
; void dzx1_smart_rcs_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC _dzx1_smart_rcs_back

EXTERN asm_dzx1_smart_rcs_back

_dzx1_smart_rcs_back:

   pop af
   pop hl
   pop de

   push de
   push hl
   push af

   jp asm_dzx1_smart_rcs_back
