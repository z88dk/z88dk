
; void *p_queue_front(p_queue_t *q)

XDEF _p_queue_front

LIB _p_forward_list_front

_p_queue_front:

   jp _p_forward_list_front

   INCLUDE "adt/p_queue/z80/asm_p_queue_front.asm"
