
; size_t b_vector_write_block(void *src, size_t n, b_vector_t *v, size_t idx)

XDEF b_vector_write_block_callee

b_vector_write_block_callee:

   pop af
   pop bc
   pop hl
   pop de
   exx
   pop hl
   exx
   push af
   
   INCLUDE "../../z80/asm_b_vector_write_block.asm"
