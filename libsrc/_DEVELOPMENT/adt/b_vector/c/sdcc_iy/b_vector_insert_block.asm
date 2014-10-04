
; void *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n)

SECTION seg_code_b_vector

PUBLIC _b_vector_insert_block

_b_vector_insert_block:

   pop af
   pop hl
   pop bc
   pop de
   
   push de
   push bc
   push hl
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert_block.asm"
