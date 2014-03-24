
; size_t bv_priority_queue_capacity(bv_priority_queue_t *q)

XDEF bv_priority_queue_capacity

;defc bv_priority_queue_capacity = asm_bv_priority_queue_capacity

bv_priority_queue_capacity:

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_capacity.asm"
