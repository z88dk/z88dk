
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

SECTION seg_code_p_forward_list

PUBLIC p_forward_list_push_front

EXTERN p_forward_list_insert_after

defc p_forward_list_push_front = p_forward_list_insert_after
