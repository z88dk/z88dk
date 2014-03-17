
; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)

XDEF b_vector_read_block_callee

LIB b_array_read_block_callee

defc b_vector_read_block_callee = b_array_read_block_callee

INCLUDE "../../z80/asm_b_vector_read_block.asm"
