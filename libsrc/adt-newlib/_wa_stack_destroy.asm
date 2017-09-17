; void wa_stack_destroy(wa_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _wa_stack_destroy_sdcc
GLOBAL _wa_stack_destroy
GLOBAL wa_stack_destroy

defc _wa_stack_destroy = wa_stack_destroy

