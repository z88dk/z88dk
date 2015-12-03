
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_push_front_callee

EXTERN p_forward_list_insert_after_callee

defc p_forward_list_push_front_callee = p_forward_list_insert_after_callee
