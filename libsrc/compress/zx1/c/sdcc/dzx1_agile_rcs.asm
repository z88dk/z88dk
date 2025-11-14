
; void dzx1_agile_rcs(void *src, void *dst)

SECTION code_clib
SECTION code_compress_zx1

PUBLIC _dzx1_agile_rcs

EXTERN asm_dzx1_agile_rcs

_dzx1_agile_rcs:

   pop af
   pop hl
   pop de
   
   push de
   push hl
   push af
   
   jp asm_dzx1_agile_rcs
