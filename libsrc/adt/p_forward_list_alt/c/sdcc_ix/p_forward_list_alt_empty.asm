
; int p_forward_list_alt_empty(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_empty

EXTERN _p_forward_list_empty

defc _p_forward_list_alt_empty = _p_forward_list_empty
