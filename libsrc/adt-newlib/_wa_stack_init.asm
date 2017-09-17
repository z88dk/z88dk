; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_string

MODULE _wa_stack_init_sdcc
GLOBAL _wa_stack_init
GLOBAL wa_stack_init

defc _wa_stack_init = wa_stack_init

