; wv_stack_t *wv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_string

MODULE _wv_stack_init_callee_sdcc
GLOBAL _wv_stack_init_callee
GLOBAL wv_stack_init_callee

defc _wv_stack_init_callee = wv_stack_init_callee

