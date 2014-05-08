
; size_t bv_priority_queue_size(bv_priority_queue_t *q)

PUBLIC bv_priority_queue_size

;defc bv_priority_queue_size = asm_bv_priority_queue_size

bv_priority_queue_size:

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_size.asm"
