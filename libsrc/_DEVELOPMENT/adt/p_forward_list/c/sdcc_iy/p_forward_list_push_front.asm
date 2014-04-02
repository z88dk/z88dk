
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

XDEF _p_forward_list_push_front

LIB _p_forward_list_insert_after

_p_forward_list_push_front:

   jp _p_forward_list_insert_after

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_push_front.asm"
