
; void p_forward_list_clear(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC _p_forward_list_clear

EXTERN _p_forward_list_init

defc _p_forward_list_clear = _p_forward_list_init
