; size_t w_vector_insert(w_vector_t *v, size_t idx, void *item)

SECTION code_clib
SECTION code_string

MODULE _w_vector_insert_sdcc
GLOBAL _w_vector_insert
GLOBAL w_vector_insert

defc _w_vector_insert = w_vector_insert

