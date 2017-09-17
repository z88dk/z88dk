; wv_stack_t *wv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_string

MODULE _wv_stack_init_sdcc
GLOBAL _wv_stack_init
GLOBAL wv_stack_init

defc _wv_stack_init = wv_stack_init

