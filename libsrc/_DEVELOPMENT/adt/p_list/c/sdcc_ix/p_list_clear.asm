
; void p_list_clear(p_list_t *list)

XDEF p_list_clear

LIB p_list_init

p_list_clear:

   jp p_list_init

   INCLUDE "adt/p_list/z80/asm_p_list_clear.asm"
