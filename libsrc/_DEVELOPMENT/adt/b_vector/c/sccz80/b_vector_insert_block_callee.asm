
; void *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n)

SECTION code_adt_b_vector

PUBLIC b_vector_insert_block_callee

b_vector_insert_block_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_insert_block.asm"
