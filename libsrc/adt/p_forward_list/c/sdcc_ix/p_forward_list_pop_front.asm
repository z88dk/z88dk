
; void *p_forward_list_pop_front(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_pop_front

EXTERN _p_forward_list_remove_after

defc _p_forward_list_pop_front = _p_forward_list_remove_after
