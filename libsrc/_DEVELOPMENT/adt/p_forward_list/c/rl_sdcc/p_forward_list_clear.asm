
; void p_forward_list_clear(p_forward_list_t *list)

XDEF p_forward_list_clear

LIB p_forward_list_init

defc p_forward_list_clear = p_forward_list_init

INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_clear.asm"
