
; int bv_priority_queue_top(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_top

EXTERN asm_bv_priority_queue_top

defc bv_priority_queue_top = asm_bv_priority_queue_top
