
; void *p_list_front(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_front

EXTERN _p_forward_list_front

defc _p_list_front = _p_forward_list_front
