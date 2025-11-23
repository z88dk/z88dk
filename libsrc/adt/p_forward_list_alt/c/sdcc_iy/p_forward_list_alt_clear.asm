
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC _p_forward_list_alt_clear

EXTERN _p_forward_list_alt_init

defc _p_forward_list_alt_clear = _p_forward_list_alt_init
