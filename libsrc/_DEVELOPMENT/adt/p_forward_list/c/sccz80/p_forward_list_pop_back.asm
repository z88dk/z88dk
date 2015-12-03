
; void *p_forward_list_pop_back(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_pop_back

EXTERN asm_p_forward_list_pop_back

defc p_forward_list_pop_back = asm_p_forward_list_pop_back
