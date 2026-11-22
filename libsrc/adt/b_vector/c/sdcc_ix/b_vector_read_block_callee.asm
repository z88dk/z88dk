
; size_t b_vector_read_block_callee(void *dst, size_t n, b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC _b_vector_read_block_callee

EXTERN _b_array_read_block_callee

defc _b_vector_read_block_callee = _b_array_read_block_callee
