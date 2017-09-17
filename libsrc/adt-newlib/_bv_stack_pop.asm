; int bv_stack_pop(bv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_pop_sdcc
GLOBAL _bv_stack_pop
GLOBAL bv_stack_pop

defc _bv_stack_pop = bv_stack_pop

