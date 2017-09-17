; size_t w_array_erase(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _w_array_erase_sdcc
GLOBAL _w_array_erase
GLOBAL w_array_erase

defc _w_array_erase = w_array_erase

