; size_t w_array_push_back(w_array_t *a, void *item)

SECTION code_clib
SECTION code_string

MODULE _w_array_push_back_callee_sdcc
GLOBAL _w_array_push_back_callee
GLOBAL w_array_push_back_callee

defc _w_array_push_back_callee = w_array_push_back_callee

