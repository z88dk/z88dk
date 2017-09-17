; size_t w_vector_append(b_vector_t *v, void *item)

SECTION code_clib
SECTION code_string

MODULE _w_vector_append_callee_sdcc
GLOBAL _w_vector_append_callee
GLOBAL w_vector_append_callee

defc _w_vector_append_callee = w_vector_append_callee

