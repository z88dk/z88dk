; size_t w_array_erase_range(w_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_string

MODULE _w_array_erase_range_sdcc
GLOBAL _w_array_erase_range
GLOBAL w_array_erase_range

defc _w_array_erase_range = w_array_erase_range

