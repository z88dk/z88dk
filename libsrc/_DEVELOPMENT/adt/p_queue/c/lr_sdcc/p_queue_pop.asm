
; void *p_queue_pop(p_queue_t *q)

XDEF p_queue_pop

LIB p_forward_list_alt_pop_front

defc p_queue_pop = p_forward_list_alt_pop_front

INCLUDE "adt/p_queue/z80/asm_p_queue_pop.asm"
