; void p_stack_push(p_stack_t *s, void *item)

SECTION code_clib
SECTION code_string

MODULE _p_stack_push_sdcc
GLOBAL _p_stack_push
GLOBAL p_stack_push

defc _p_stack_push = p_stack_push

