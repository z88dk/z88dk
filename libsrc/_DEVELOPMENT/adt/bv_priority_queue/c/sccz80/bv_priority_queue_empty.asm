
; int bv_priority_queue_empty(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_empty

EXTERN asm_bv_priority_queue_empty

defc bv_priority_queue_empty = asm_bv_priority_queue_empty
