; int wv_stack_reserve(wv_stack_t *s, size_t n)

SECTION code_clib
SECTION code_string

MODULE _wv_stack_reserve_sdcc
GLOBAL _wv_stack_reserve
GLOBAL wv_stack_reserve

defc _wv_stack_reserve = wv_stack_reserve

