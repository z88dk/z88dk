
; void p_list_clear(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC _p_list_clear

EXTERN _p_list_init

defc _p_list_clear = _p_list_init
