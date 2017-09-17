; b_array_t *b_array_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_string

MODULE _b_array_init_callee_sdcc
GLOBAL _b_array_init_callee
GLOBAL b_array_init_callee

defc _b_array_init_callee = b_array_init_callee

