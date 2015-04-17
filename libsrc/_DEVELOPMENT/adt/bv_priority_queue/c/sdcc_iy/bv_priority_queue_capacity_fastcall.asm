
; size_t bv_priority_queue_capacity_fastcall(bv_priority_queue_t *q)

SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_capacity_fastcall

defc _bv_priority_queue_capacity = asm_bv_priority_queue_capacity

INCLUDE "adt/bv_priority_queue/z80/asm_bv_priority_queue_capacity.asm"
