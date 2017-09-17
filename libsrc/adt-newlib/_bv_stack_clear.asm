; void bv_stack_clear(bv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_clear_sdcc
GLOBAL _bv_stack_clear
GLOBAL bv_stack_clear

defc _bv_stack_clear = bv_stack_clear

