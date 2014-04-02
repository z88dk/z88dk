
; void *p_queue_pop(p_queue_t *q)

XDEF _p_queue_pop

LIB _p_forward_list_alt_pop_front

_p_queue_pop:

   jp _p_forward_list_alt_pop_front

   INCLUDE "adt/p_queue/z80/asm_p_queue_pop.asm"
