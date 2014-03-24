
; int wv_priority_queue_empty(wv_priority_queue_t *q)

XDEF wv_priority_queue_empty

LIB wa_priority_queue_empty

defc wv_priority_queue_empty = wa_priority_queue_empty

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_empty.asm"
