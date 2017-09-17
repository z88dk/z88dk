; size_t w_array_erase_range(w_array_t *a, size_t idx_first, size_t idx_last)

SECTION code_clib
SECTION code_string

MODULE _w_array_erase_range_callee_sdcc
GLOBAL _w_array_erase_range_callee
GLOBAL w_array_erase_range_callee

defc _w_array_erase_range_callee = w_array_erase_range_callee

