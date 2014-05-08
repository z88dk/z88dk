
; void p_list_clear(p_list_t *list)

PUBLIC _p_list_clear

EXTERN _p_list_init

_p_list_clear:

   jp _p_list_init

   INCLUDE "adt/p_list/z80/asm_p_list_clear.asm"
