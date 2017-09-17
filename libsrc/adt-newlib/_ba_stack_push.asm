; int ba_stack_push(ba_stack_t *s, int c)

SECTION code_clib
SECTION code_string

MODULE _ba_stack_push_sdcc
GLOBAL _ba_stack_push
GLOBAL ba_stack_push

defc _ba_stack_push = ba_stack_push

