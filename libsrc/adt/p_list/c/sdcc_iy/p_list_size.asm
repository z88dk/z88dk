
; size_t p_list_size(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_size

EXTERN _p_forward_list_size

defc _p_list_size = _p_forward_list_size
