
; void p_stack_push(p_stack_t *s, void *item)

XLIB p_stack_push

LIB p_forward_list_insert_after

defc p_stack_push = p_forward_list_insert_after
