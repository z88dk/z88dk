
; int p_list_empty(p_list_t *list)

SECTION code_clib
SECTION code_adt_p_list

PUBLIC p_list_empty

EXTERN asm_p_list_empty

defc p_list_empty = asm_p_list_empty
