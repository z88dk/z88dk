
; void p_stack_push(p_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC _p_stack_push

EXTERN _p_forward_list_insert_after

defc _p_stack_push = _p_forward_list_insert_after
