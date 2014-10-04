
; int bv_priority_queue_empty(bv_priority_queue_t *q)

SECTION seg_code_bv_priority_queue

PUBLIC bv_priority_queue_empty

defc bv_priority_queue_empty = asm_bv_priority_queue_empty

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_empty.asm"
