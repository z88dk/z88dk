
; void *p_forward_list_alt_front(p_forward_list_alt_t *list)

XDEF p_forward_list_alt_front

LIB p_forward_list_front

defc p_forward_list_alt_front = p_forward_list_front

INCLUDE "../../z80/asm_p_forward_list_alt_front.asm"
