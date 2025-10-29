
; size_t p_forward_list_alt_size(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_size

EXTERN _p_forward_list_size

defc _p_forward_list_alt_size = _p_forward_list_size
