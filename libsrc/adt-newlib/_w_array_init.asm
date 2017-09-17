; w_array_t *w_array_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_string

MODULE _w_array_init_sdcc
GLOBAL _w_array_init
GLOBAL w_array_init

defc _w_array_init = w_array_init

