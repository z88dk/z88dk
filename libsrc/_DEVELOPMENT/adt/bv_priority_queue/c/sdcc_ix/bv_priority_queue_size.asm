
; size_t bv_priority_queue_size(bv_priority_queue_t *q)

XDEF bv_priority_queue_size

LIB ba_priority_queue_size

bv_priority_queue_size:

   jp ba_priority_queue_size

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_size.asm"
