
; void p_stack_push(p_stack_t *s, void *item)

SECTION code_clib
SECTION code_adt_p_stack

PUBLIC p_stack_push

EXTERN p_forward_list_insert_after

defc p_stack_push = p_forward_list_insert_after
