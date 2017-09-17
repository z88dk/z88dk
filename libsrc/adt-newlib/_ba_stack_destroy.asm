; void ba_stack_destroy(ba_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _ba_stack_destroy_sdcc
GLOBAL _ba_stack_destroy
GLOBAL ba_stack_destroy

defc _ba_stack_destroy = ba_stack_destroy

