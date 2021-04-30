
; void dzx0_agile_rcs(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx0

PUBLIC dzx0_agile_rcs

EXTERN asm_dzx0_agile_rcs

dzx0_agile_rcs:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_dzx0_agile_rcs
