; size_t w_vector_erase_range(w_vector_t *v, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_string

MODULE _w_vector_erase_range_callee_sdcc
GLOBAL _w_vector_erase_range_callee
GLOBAL w_vector_erase_range_callee

defc _w_vector_erase_range_callee = w_vector_erase_range_callee

