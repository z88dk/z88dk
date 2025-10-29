
; void *p_stack_top(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_top

EXTERN _p_forward_list_front

defc _p_stack_top = _p_forward_list_front
