
; size_t bv_priority_queue_capacity(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_capacity

EXTERN asm_bv_priority_queue_capacity

defc bv_priority_queue_capacity = asm_bv_priority_queue_capacity
