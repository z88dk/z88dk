
; void *b_vector_insert_block_callee(b_vector_t *v, size_t idx, size_t n)

SECTION code_adt_b_vector

PUBLIC _b_vector_insert_block_callee

_b_vector_insert_block_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert_block.asm"
