
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

PUBLIC _p_forward_list_push_front

EXTERN _p_forward_list_insert_after

_p_forward_list_push_front:

   jp _p_forward_list_insert_after

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_push_front.asm"
