
; size_t p_forward_list_size(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_size

EXTERN asm_p_forward_list_size

defc p_forward_list_size = asm_p_forward_list_size
