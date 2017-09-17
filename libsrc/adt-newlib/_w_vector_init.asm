; w_vector_t *w_vector_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_string

MODULE _w_vector_init_sdcc
GLOBAL _w_vector_init
GLOBAL w_vector_init

defc _w_vector_init = w_vector_init

