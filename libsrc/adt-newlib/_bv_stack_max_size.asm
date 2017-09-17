; size_t bv_stack_max_size(bv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_max_size_sdcc
GLOBAL _bv_stack_max_size
GLOBAL bv_stack_max_size

defc _bv_stack_max_size = bv_stack_max_size

