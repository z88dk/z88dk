
; size_t wv_priority_queue_capacity(wv_priority_queue_t *q)

PUBLIC _wv_priority_queue_capacity

EXTERN _wa_priority_queue_capacity

_wv_priority_queue_capacity:

   jp _wa_priority_queue_capacity

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_capacity.asm"
