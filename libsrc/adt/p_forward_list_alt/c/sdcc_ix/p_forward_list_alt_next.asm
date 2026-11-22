
; void *p_forward_list_alt_next(void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_next

EXTERN _p_forward_list_next

defc _p_forward_list_alt_next = _p_forward_list_next
