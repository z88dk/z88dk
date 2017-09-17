; int wv_stack_push(wv_stack_t *s, void *item)

SECTION code_clib
SECTION code_string

MODULE _wv_stack_push_sdcc
GLOBAL _wv_stack_push
GLOBAL wv_stack_push

defc _wv_stack_push = wv_stack_push

