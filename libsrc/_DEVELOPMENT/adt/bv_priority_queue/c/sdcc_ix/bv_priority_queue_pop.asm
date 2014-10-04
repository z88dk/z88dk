
; int bv_priority_queue_pop(bv_priority_queue_t *q)

SECTION seg_code_bv_priority_queue

PUBLIC _bv_priority_queue_pop

EXTERN _ba_priority_queue_pop

defc _bv_priority_queue_pop = _ba_priority_queue_pop

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_pop.asm"
