
; size_t wv_priority_queue_size(wv_priority_queue_t *q)

XDEF _wv_priority_queue_size

LIB _wa_priority_queue_size

_wv_priority_queue_size:

   jp _wa_priority_queue_size

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_size.asm"
