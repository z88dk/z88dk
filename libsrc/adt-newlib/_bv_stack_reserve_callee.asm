; int bv_stack_reserve(bv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_reserve_callee_sdcc
GLOBAL _bv_stack_reserve_callee
GLOBAL bv_stack_reserve_callee

defc _bv_stack_reserve_callee = bv_stack_reserve_callee

