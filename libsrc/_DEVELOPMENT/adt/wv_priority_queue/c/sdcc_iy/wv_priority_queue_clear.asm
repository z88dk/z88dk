
; void wv_priority_queue_clear(wv_priority_queue_t *q)

XDEF wv_priority_queue_clear

LIB wa_priority_queue_clear

wv_priority_queue_clear:

   jp wa_priority_queue_clear

   INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_clear.asm"
