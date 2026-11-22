
; int p_list_empty(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_empty

EXTERN _p_forward_list_empty

defc _p_list_empty = _p_forward_list_empty
