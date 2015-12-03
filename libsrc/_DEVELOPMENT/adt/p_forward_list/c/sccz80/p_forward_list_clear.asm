
; void p_forward_list_clear(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_clear

EXTERN asm_p_forward_list_clear

defc p_forward_list_clear = asm_p_forward_list_clear
