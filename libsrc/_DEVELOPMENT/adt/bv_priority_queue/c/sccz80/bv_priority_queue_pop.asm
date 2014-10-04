
; int bv_priority_queue_pop(bv_priority_queue_t *q)

SECTION seg_code_bv_priority_queue

PUBLIC bv_priority_queue_pop

defc bv_priority_queue_pop = asm_bv_priority_queue_pop

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_pop.asm"
