
; void *p_forward_list_pop_front(p_forward_list_t *list)

XDEF p_forward_list_pop_front

LIB p_forward_list_remove_after

defc p_forward_list_pop_front = p_forward_list_remove_after

INCLUDE "../../z80/asm_p_forward_list_pop_front.asm"
