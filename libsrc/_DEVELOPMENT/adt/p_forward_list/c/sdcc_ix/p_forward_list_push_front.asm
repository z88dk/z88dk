
; void p_forward_list_push_front(p_forward_list_t *list, void *item)

XDEF p_forward_list_push_front

LIB p_forward_list_insert_after

p_forward_list_push_front:

   jp p_forward_list_insert_after

   INCLUDE "adt/p_forward_list/z80/asm_p_forward_list_push_front.asm"
