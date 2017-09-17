; size_t w_vector_insert_n(w_vector_t *v, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_string

MODULE _w_vector_insert_n_callee_sdcc
GLOBAL _w_vector_insert_n_callee
GLOBAL w_vector_insert_n_callee

defc _w_vector_insert_n_callee = w_vector_insert_n_callee

