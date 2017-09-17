; void *b_vector_append_block(b_vector_t *v, size_t n)

SECTION code_clib
SECTION code_string

MODULE _b_vector_append_block_callee_sdcc
GLOBAL _b_vector_append_block_callee
GLOBAL b_vector_append_block_callee

defc _b_vector_append_block_callee = b_vector_append_block_callee

