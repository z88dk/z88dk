
; void dzx7_agile_rcs(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx7

PUBLIC _dzx7_agile_rcs

EXTERN asm_dzx7_agile_rcs

_dzx7_agile_rcs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx7_agile_rcs
