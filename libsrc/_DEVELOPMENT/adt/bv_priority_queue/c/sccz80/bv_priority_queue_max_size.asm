
; size_t bv_priority_queue_max_size(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_max_size

EXTERN asm_bv_priority_queue_max_size

defc bv_priority_queue_max_size = asm_bv_priority_queue_max_size
