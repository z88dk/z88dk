; size_t w_array_erase(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _w_array_erase_callee_sdcc
GLOBAL _w_array_erase_callee
GLOBAL w_array_erase_callee

defc _w_array_erase_callee = w_array_erase_callee

