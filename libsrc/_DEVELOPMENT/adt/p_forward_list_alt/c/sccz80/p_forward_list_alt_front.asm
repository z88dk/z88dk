
; void *p_forward_list_alt_front(p_forward_list_alt_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list_alt

PUBLIC p_forward_list_alt_front

EXTERN asm_p_forward_list_alt_front

defc p_forward_list_alt_front = asm_p_forward_list_alt_front
