; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_string

MODULE _w_array_insert_n_callee_sdcc
GLOBAL _w_array_insert_n_callee
GLOBAL w_array_insert_n_callee

defc _w_array_insert_n_callee = w_array_insert_n_callee

