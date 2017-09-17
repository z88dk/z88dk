; void wa_stack_clear(wa_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _wa_stack_clear_sdcc
GLOBAL _wa_stack_clear
GLOBAL wa_stack_clear

defc _wa_stack_clear = wa_stack_clear

