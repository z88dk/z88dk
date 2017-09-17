; size_t w_vector_push_back(w_vector_t *v, void *item)

SECTION code_clib
SECTION code_string

MODULE _w_vector_push_back_callee_sdcc
GLOBAL _w_vector_push_back_callee
GLOBAL w_vector_push_back_callee

defc _w_vector_push_back_callee = w_vector_push_back_callee

