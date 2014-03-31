
; void p_forward_list_alt_clear(p_forward_list_alt_t *list)

XDEF p_forward_list_alt_clear

LIB p_forward_list_alt_init

p_forward_list_alt_clear:

   jp p_forward_list_alt_init

   INCLUDE "adt/p_forward_list_alt/z80/asm_p_forward_list_alt_clear.asm"
