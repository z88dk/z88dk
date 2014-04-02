
; size_t p_list_size(p_list_t *list)

XDEF _p_list_size

LIB _p_forward_list_size

_p_list_size:

   jp _p_forward_list_size

   INCLUDE "adt/p_list/z80/asm_p_list_size.asm"
