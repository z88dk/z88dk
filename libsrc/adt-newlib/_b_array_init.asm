; b_array_t *b_array_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_string

MODULE _b_array_init_sdcc
GLOBAL _b_array_init
GLOBAL b_array_init

defc _b_array_init = b_array_init

