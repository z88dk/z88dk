
; void *p_list_front(p_list_t *list)

PUBLIC _p_list_front

EXTERN _p_forward_list_front

_p_list_front:

   jp _p_forward_list_front

   INCLUDE "adt/p_list/z80/asm_p_list_front.asm"
