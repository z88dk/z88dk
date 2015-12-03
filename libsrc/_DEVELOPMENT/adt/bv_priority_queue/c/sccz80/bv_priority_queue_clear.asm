
; void bv_priority_queue_clear(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_clear

EXTERN asm_bv_priority_queue_clear

defc bv_priority_queue_clear = asm_bv_priority_queue_clear
