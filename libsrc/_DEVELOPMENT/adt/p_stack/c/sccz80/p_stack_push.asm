
; void p_stack_push(p_stack_t *s, void *item)

SECTION seg_code_p_stack

PUBLIC p_stack_push

EXTERN p_forward_list_insert_after

defc p_stack_push = p_forward_list_insert_after
