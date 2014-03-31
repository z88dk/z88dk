
; void *bv_priority_queue_data(bv_priority_queue_t *q)

XDEF bv_priority_queue_data

LIB ba_priority_queue_data

bv_priority_queue_data:

   jp ba_priority_queue_data

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_data.asm"
