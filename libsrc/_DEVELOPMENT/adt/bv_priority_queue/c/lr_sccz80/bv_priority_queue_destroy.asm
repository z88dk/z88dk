
; void bv_priority_queue_destroy(bv_priority_queue_t *q)

PUBLIC bv_priority_queue_destroy

;defc bv_priority_queue_destroy = asm_bv_priority_queue_destroy

bv_priority_queue_destroy:

   INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_destroy.asm"
