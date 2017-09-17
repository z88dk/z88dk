; wa_stack_t *wa_stack_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_string

MODULE _wa_stack_init_callee_sdcc
GLOBAL _wa_stack_init_callee
GLOBAL wa_stack_init_callee

defc _wa_stack_init_callee = wa_stack_init_callee

