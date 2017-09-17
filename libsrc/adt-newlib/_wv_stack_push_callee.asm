; int wv_stack_push(wv_stack_t *s, void *item)

SECTION code_clib
SECTION code_string

MODULE _wv_stack_push_callee_sdcc
GLOBAL _wv_stack_push_callee
GLOBAL wv_stack_push_callee

defc _wv_stack_push_callee = wv_stack_push_callee

