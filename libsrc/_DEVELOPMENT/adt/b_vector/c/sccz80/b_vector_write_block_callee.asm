
; size_t b_vector_write_block(void *src, size_t n, b_vector_t *v, size_t idx)

SECTION seg_code_b_vector

PUBLIC b_vector_write_block_callee

b_vector_write_block_callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop hl
   exx
   push af
   
   INCLUDE "adt/b_vector/z80/asm_b_vector_write_block.asm"
