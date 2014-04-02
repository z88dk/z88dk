
; void *wv_priority_queue_pop(wv_priority_queue_t *q)

XDEF _wv_priority_queue_pop

LIB _wa_priority_queue_pop

_wv_priority_queue_pop:

   jp _wa_priority_queue_pop

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_pop.asm"
