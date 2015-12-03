
; void bv_priority_queue_destroy(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_destroy

EXTERN asm_bv_priority_queue_destroy

defc bv_priority_queue_destroy = asm_bv_priority_queue_destroy
