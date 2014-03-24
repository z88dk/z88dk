
; size_t b_vector_erase_block(b_vector_t *v, size_t idx, size_t n)

XDEF b_vector_erase_block_callee

LIB b_array_erase_block_callee

;defc b_vector_erase_block_callee = b_array_erase_block_callee

b_vector_erase_block_callee:

   jp b_array_erase_block_callee

INCLUDE "adt/b_vector/z80/asm_b_vector_erase_block.asm"
