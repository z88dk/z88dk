; void wv_stack_clear(wv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _wv_stack_clear_sdcc
GLOBAL _wv_stack_clear
GLOBAL wv_stack_clear

defc _wv_stack_clear = wv_stack_clear

