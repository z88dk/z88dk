
; int p_list_empty(p_list_t *list)

XDEF p_list_empty

LIB p_forward_list_empty

p_list_empty:

   jp p_forward_list_empty

   INCLUDE "adt/p_list/z80/asm_p_list_empty.asm"
