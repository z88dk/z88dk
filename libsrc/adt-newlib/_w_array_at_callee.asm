; void *w_array_at(w_array_t *a, size_t idx)

SECTION code_clib
SECTION code_string

MODULE _w_array_at_callee_sdcc
GLOBAL _w_array_at_callee
GLOBAL w_array_at_callee

defc _w_array_at_callee = w_array_at_callee

