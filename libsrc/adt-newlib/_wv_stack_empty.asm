; int wv_stack_empty(wv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _wv_stack_empty_sdcc
GLOBAL _wv_stack_empty
GLOBAL wv_stack_empty

defc _wv_stack_empty = wv_stack_empty

