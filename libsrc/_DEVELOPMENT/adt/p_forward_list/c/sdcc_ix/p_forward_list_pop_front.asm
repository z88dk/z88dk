
; void *p_forward_list_pop_front(p_forward_list_t *list)

XDEF _p_forward_list_pop_front

LIB _p_forward_list_remove_after

_p_forward_list_pop_front:

   jp _p_forward_list_remove_after

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_pop_front.asm"
