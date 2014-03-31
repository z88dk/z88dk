
; int bv_priority_queue_empty(bv_priority_queue_t *q)

XDEF bv_priority_queue_empty

LIB ba_priority_queue_empty

bv_priority_queue_empty:

   jp ba_priority_queue_empty

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_empty.asm"
