
; void *wv_priority_queue_top(wv_priority_queue_t *q)

XDEF wv_priority_queue_top

LIB wa_priority_queue_top

wv_priority_queue_top:

   jp wa_priority_queue_top

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_top.asm"
