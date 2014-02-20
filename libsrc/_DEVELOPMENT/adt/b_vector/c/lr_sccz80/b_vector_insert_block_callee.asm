
; void *b_vector_insert_block(b_vector_t *v, size_t idx, size_t n)

XDEF b_vector_insert_block_callee

b_vector_insert_block_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_vector_insert_block.asm"
