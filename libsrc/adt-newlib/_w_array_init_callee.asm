; w_array_t *w_array_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_string

MODULE _w_array_init_callee_sdcc
GLOBAL _w_array_init_callee
GLOBAL w_array_init_callee

defc _w_array_init_callee = w_array_init_callee

