; size_t b_vector_read_block(void *dst, size_t n, b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _b_vector_read_block_sdcc
GLOBAL _b_vector_read_block
GLOBAL b_vector_read_block

defc _b_vector_read_block = b_vector_read_block

