
; void *wv_priority_queue_top(wv_priority_queue_t *q)

XDEF _wv_priority_queue_top

LIB _wa_priority_queue_top

_wv_priority_queue_top:

   jp _wa_priority_queue_top

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_top.asm"
