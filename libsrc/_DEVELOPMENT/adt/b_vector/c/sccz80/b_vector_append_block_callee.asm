
; void *b_vector_append_block(b_vector_t *v, size_t n)

SECTION seg_code_b_vector

PUBLIC b_vector_append_block_callee

b_vector_append_block_callee:

   pop hl
   pop de
   ex (sp),hl
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_append_block.asm"
