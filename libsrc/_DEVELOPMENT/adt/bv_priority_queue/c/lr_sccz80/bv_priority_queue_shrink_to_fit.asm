
; int bv_priority_queue_shrink_to_fit(bv_priority_queue_t *q)

XDEF bv_priority_queue_shrink_to_fit

;defc bv_priority_queue_shrink_to_fit = asm_bv_priority_queue_shrink_to_fit

bv_priority_queue_shrink_to_fit:

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_shrink_to_fit.asm"
