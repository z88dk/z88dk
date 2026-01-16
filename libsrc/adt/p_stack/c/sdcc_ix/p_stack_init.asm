
; void p_stack_init(void *p)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_init

EXTERN _p_forward_list_init

defc _p_stack_init = _p_forward_list_init
