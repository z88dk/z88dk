
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)

XDEF b_vector_erase_block_callee

b_vector_erase_block_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl
   
   INCLUDE "../../z80/asm_b_vector_erase_block.asm"
