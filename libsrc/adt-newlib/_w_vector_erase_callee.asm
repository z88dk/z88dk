; size_t w_vector_erase(w_vector_t *v, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _w_vector_erase_callee_sdcc
GLOBAL _w_vector_erase_callee
GLOBAL w_vector_erase_callee

defc _w_vector_erase_callee = w_vector_erase_callee

