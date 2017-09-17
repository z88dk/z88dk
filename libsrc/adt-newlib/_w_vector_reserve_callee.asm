; int w_vector_reserve(w_vector_t *v, size_t n)

SECTION code_clib
SECTION code_string

MODULE _w_vector_reserve_callee_sdcc
GLOBAL _w_vector_reserve_callee
GLOBAL w_vector_reserve_callee

defc _w_vector_reserve_callee = w_vector_reserve_callee

