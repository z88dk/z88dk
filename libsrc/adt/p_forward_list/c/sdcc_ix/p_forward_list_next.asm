
; void *p_forward_list_next(void *item)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_next

EXTERN _p_forward_list_front

defc _p_forward_list_next = _p_forward_list_front
