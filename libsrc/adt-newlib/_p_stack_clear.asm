; void p_stack_clear(p_stack_t *s)

SECTION code_clib
SECTION code_string

MODULE _p_stack_clear_sdcc
GLOBAL _p_stack_clear
GLOBAL p_stack_clear

defc _p_stack_clear = p_stack_clear

