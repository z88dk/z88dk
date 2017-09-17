; size_t w_array_insert_n(w_array_t *a, size_t idx, size_t n, void *item)

SECTION code_clib
SECTION code_string

MODULE _w_array_insert_n_sdcc
GLOBAL _w_array_insert_n
GLOBAL w_array_insert_n

defc _w_array_insert_n = w_array_insert_n

