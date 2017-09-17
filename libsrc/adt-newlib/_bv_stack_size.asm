; size_t bv_stack_size(bv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_size_sdcc
GLOBAL _bv_stack_size
GLOBAL bv_stack_size

defc _bv_stack_size = bv_stack_size

