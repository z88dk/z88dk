; void wv_stack_destroy(wv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _wv_stack_destroy_sdcc
GLOBAL _wv_stack_destroy
GLOBAL wv_stack_destroy

defc _wv_stack_destroy = wv_stack_destroy

