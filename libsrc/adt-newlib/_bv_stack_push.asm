; int bv_stack_push(bv_stack_t *s, int c)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_push_sdcc
GLOBAL _bv_stack_push
GLOBAL bv_stack_push

defc _bv_stack_push = bv_stack_push

