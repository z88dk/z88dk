
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_push_front

EXTERN _p_forward_list_insert_after

defc _p_forward_list_push_front = _p_forward_list_insert_after
