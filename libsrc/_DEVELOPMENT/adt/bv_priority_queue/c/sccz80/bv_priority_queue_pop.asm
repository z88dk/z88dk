
; int bv_priority_queue_pop(bv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC bv_priority_queue_pop

EXTERN asm_bv_priority_queue_pop

defc bv_priority_queue_pop = asm_bv_priority_queue_pop
