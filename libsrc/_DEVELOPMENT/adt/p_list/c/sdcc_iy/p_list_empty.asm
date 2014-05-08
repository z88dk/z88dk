
; int p_list_empty(p_list_t *list)

PUBLIC _p_list_empty

EXTERN _p_forward_list_empty

_p_list_empty:

   jp _p_forward_list_empty

   INCLUDE "adt/p_list/z80/asm_p_list_empty.asm"
