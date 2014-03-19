
; size_t p_list_size(p_list_t *list)

XDEF p_list_size

LIB p_forward_list_size

defc p_list_size = p_forward_list_size

INCLUDE "../../z80/asm_p_list_size.asm"
