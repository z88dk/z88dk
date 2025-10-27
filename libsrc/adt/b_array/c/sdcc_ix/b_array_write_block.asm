
; size_t b_array_write_block(void *src, size_t n, b_array_t *a, size_t idx)

SECTION code_clib
SECTION code_adt_b_array

PUBLIC _b_array_write_block

EXTERN asm_b_array_write_block

_b_array_write_block:

   pop af
   exx
   pop hl
   exx
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push hl
   push af
   
   jp asm_b_array_write_block
