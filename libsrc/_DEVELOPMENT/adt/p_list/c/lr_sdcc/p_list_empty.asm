
; int p_list_empty(p_list_t *list)

XDEF p_list_empty

LIB p_forward_list_empty

defc p_list_empty = p_forward_list_empty

INCLUDE "../../z80/asm_p_list_empty.asm"
