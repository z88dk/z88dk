; int bv_stack_push(bv_stack_t *s, int c)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_push_callee_sdcc
GLOBAL _bv_stack_push_callee
GLOBAL bv_stack_push_callee

defc _bv_stack_push_callee = bv_stack_push_callee

