; void p_stack_push(p_stack_t *s, void *item)

SECTION code_clib
SECTION code_string

MODULE _p_stack_push_callee_sdcc
GLOBAL _p_stack_push_callee
GLOBAL p_stack_push_callee

defc _p_stack_push_callee = p_stack_push_callee

