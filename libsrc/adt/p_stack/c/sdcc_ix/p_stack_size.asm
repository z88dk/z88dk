
; size_t p_stack_size(p_stack_t *s)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_size

EXTERN _p_forward_list_size

defc _p_stack_size = _p_forward_list_size
