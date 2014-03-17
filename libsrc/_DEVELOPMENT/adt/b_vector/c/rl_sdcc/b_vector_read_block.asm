
; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)

XDEF b_vector_read_block

LIB b_array_read_block

defc b_vector_read_block = b_array_read_block

INCLUDE "../../z80/asm_b_vector_read_block.asm"
