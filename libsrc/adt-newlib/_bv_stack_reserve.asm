; int bv_stack_reserve(bv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_reserve_sdcc
GLOBAL _bv_stack_reserve
GLOBAL bv_stack_reserve

defc _bv_stack_reserve = bv_stack_reserve

