
; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)

SECTION code_adt_b_vector

PUBLIC _b_vector_read_block

EXTERN _b_array_read_block

defc _b_vector_read_block = _b_array_read_block

INCLUDE "adt/b_vector/z80/asm_b_vector_read_block.asm"
