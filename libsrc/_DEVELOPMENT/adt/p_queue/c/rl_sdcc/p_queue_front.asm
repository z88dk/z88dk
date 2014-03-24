
; void *p_queue_front(p_queue_t *q)

XDEF p_queue_front

LIB p_forward_list_front

defc p_queue_front = p_forward_list_front

INCLUDE "adt/p_queue/z80/asm_p_queue_front.asm"
