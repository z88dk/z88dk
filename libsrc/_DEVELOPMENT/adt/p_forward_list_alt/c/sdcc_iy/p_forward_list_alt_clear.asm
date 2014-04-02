
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)

XDEF _p_forward_list_alt_clear

LIB _p_forward_list_alt_init

_p_forward_list_alt_clear:

   jp _p_forward_list_alt_init

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_clear.asm"
