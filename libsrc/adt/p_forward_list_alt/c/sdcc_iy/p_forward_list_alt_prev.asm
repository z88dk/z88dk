
; void *p_forward_list_alt_prev(forward_list_alt_t *list, void *item)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_prev

EXTERN p_forward_list_prev

defc p_forward_list_alt_prev = p_forward_list_prev
