
; size_t wv_priority_queue_size(wv_priority_queue_t *q)

PUBLIC _wv_priority_queue_size

EXTERN _wa_priority_queue_size

_wv_priority_queue_size:

   jp _wa_priority_queue_size

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_size.asm"
