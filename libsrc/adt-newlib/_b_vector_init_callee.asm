; void *b_vector_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_string

MODULE _b_vector_init_callee_sdcc
GLOBAL _b_vector_init_callee
GLOBAL b_vector_init_callee

defc _b_vector_init_callee = b_vector_init_callee

