
; void ba_priority_queue_destroy(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_destroy

EXTERN asm_ba_priority_queue_destroy

defc ba_priority_queue_destroy = asm_ba_priority_queue_destroy
