
; size_t p_forward_list_alt_size(p_forward_list_alt_t *list)

XDEF p_forward_list_alt_size

LIB p_forward_list_size

p_forward_list_alt_size:

   jp p_forward_list_size

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_size.asm"
