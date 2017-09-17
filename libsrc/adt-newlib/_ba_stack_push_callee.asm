; int ba_stack_push(ba_stack_t *s, int c)

SECTION code_clib
SECTION code_string

MODULE _ba_stack_push_callee_sdcc
GLOBAL _ba_stack_push_callee
GLOBAL ba_stack_push_callee

defc _ba_stack_push_callee = ba_stack_push_callee

