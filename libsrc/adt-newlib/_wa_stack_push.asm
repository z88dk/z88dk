; int wa_stack_push(wa_stack_t *s, void *item)

SECTION code_clib
SECTION code_string

MODULE _wa_stack_push_sdcc
GLOBAL _wa_stack_push
GLOBAL wa_stack_push

defc _wa_stack_push = wa_stack_push

