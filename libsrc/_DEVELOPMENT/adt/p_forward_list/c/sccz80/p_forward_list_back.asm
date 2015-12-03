
; void *p_forward_list_back(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_back

EXTERN asm_p_forward_list_back

defc p_forward_list_back = asm_p_forward_list_back
