
; int p_forward_list_empty(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_empty

EXTERN asm_p_forward_list_empty

defc p_forward_list_empty = asm_p_forward_list_empty
