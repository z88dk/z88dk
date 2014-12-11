
; int bv_priority_queue_top(bv_priority_queue_t *q)

SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_top

defc bv_priority_queue_top = asm_bv_priority_queue_top

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_top.asm"
