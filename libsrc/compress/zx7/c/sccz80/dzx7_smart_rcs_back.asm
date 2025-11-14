
; void dzx7_smart_rcs_back(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC dzx7_smart_rcs_back

EXTERN asm_dzx7_smart_rcs_back

dzx7_smart_rcs_back:

   pop af
   pop de
   pop hl

   push hl
   push de
   push af

   jp asm_dzx7_smart_rcs_back
