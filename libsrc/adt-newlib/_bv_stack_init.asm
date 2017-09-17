; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_init_sdcc
GLOBAL _bv_stack_init
GLOBAL bv_stack_init

defc _bv_stack_init = bv_stack_init

