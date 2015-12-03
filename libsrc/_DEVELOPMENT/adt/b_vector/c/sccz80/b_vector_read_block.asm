
; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_adt_b_vector

PUBLIC b_vector_read_block

EXTERN b_array_read_block

defc b_vector_read_block = b_array_read_block
