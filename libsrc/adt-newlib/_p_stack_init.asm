; void p_stack_init(void *p)

SECTION code_clib
SECTION code_string

MODULE _p_stack_init_sdcc
GLOBAL _p_stack_init
GLOBAL p_stack_init

defc _p_stack_init = p_stack_init

