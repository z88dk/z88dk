; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_string

MODULE _w_vector_init_callee_sdcc
GLOBAL _w_vector_init_callee
GLOBAL w_vector_init_callee

defc _w_vector_init_callee = w_vector_init_callee

