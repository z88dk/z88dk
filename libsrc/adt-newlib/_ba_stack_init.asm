; ba_stack_t *ba_stack_init(void *p, void *data, size_t capacity)

SECTION code_clib
SECTION code_string

MODULE _ba_stack_init_sdcc
GLOBAL _ba_stack_init
GLOBAL ba_stack_init

defc _ba_stack_init = ba_stack_init

