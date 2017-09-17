; void bv_stack_destroy(bv_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _bv_stack_destroy_sdcc
GLOBAL _bv_stack_destroy
GLOBAL bv_stack_destroy

defc _bv_stack_destroy = bv_stack_destroy

