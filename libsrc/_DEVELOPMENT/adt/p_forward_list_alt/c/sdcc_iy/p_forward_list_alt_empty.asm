
; int p_forward_list_alt_empty(p_forward_list_alt_t *list)

XDEF _p_forward_list_alt_empty

LIB _p_forward_list_empty

_p_forward_list_alt_empty:

   jp _p_forward_list_empty

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_empty.asm"
