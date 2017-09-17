; int wa_stack_push(wa_stack_t *s, void *item)

SECTION code_clib
SECTION code_string

MODULE _wa_stack_push_callee_sdcc
GLOBAL _wa_stack_push_callee
GLOBAL wa_stack_push_callee

defc _wa_stack_push_callee = wa_stack_push_callee

