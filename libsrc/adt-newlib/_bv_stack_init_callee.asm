; bv_stack_t *bv_stack_init(void *p, size_t capacity, size_t max_size)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_init_callee_sdcc
GLOBAL _bv_stack_init_callee
GLOBAL bv_stack_init_callee

defc _bv_stack_init_callee = bv_stack_init_callee

