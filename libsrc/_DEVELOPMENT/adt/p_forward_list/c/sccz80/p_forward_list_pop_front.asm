
; void *p_forward_list_pop_front(p_forward_list_t *list)

SECTION code_clib
SECTION code_adt_p_forward_list

PUBLIC p_forward_list_pop_front

EXTERN asm_p_forward_list_pop_front

defc p_forward_list_pop_front = asm_p_forward_list_pop_front
