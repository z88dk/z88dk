
; void *p_queue_front(p_queue_t *q)

PUBLIC _p_queue_front

EXTERN _p_forward_list_front

_p_queue_front:

   jp _p_forward_list_front

   INCLUDE "adt/p_queue/z80/asm_p_queue_front.asm"
