
; void p_stack_clear(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_clear

EXTERN _p_forward_list_init

defc _p_stack_clear = _p_forward_list_init
