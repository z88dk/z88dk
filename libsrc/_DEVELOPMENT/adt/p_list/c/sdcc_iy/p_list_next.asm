
; void *p_list_next(void *item)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_next

EXTERN _p_forward_list_next

defc p_list_next = _p_forward_list_next
