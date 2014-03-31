
; int p_forward_list_alt_empty(p_forward_list_alt_t *list)

XDEF p_forward_list_alt_empty

LIB p_forward_list_empty

p_forward_list_alt_empty:

   jp p_forward_list_empty

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_empty.asm"
