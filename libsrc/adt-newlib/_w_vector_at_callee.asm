; void *w_vector_at(b_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _w_vector_at_callee_sdcc
GLOBAL _w_vector_at_callee
GLOBAL w_vector_at_callee

defc _w_vector_at_callee = w_vector_at_callee

