
; void *wv_priority_queue_pop(wv_priority_queue_t *q)

XDEF wv_priority_queue_pop

LIB wa_priority_queue_pop

defc wv_priority_queue_pop = wa_priority_queue_pop

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_pop.asm"
