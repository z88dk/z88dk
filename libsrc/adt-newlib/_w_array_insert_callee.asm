; size_t w_array_insert(w_array_t *a, size_t idx, void *item)

SECTION code_clib
SECTION code_string

MODULE _w_array_insert_callee_sdcc
GLOBAL _w_array_insert_callee
GLOBAL w_array_insert_callee

defc _w_array_insert_callee = w_array_insert_callee

