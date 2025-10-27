
; int p_stack_empty(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_empty

EXTERN _p_forward_list_empty

defc _p_stack_empty = _p_forward_list_empty
