; int bv_stack_empty(bv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_empty_sdcc
GLOBAL _bv_stack_empty
GLOBAL bv_stack_empty

defc _bv_stack_empty = bv_stack_empty

