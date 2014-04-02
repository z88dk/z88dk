
; void *p_list_front(p_list_t *list)

XDEF _p_list_front

LIB _p_forward_list_front

_p_list_front:

   jp _p_forward_list_front

   INCLUDE "adt/p_list/z80/asm_p_list_front.asm"
