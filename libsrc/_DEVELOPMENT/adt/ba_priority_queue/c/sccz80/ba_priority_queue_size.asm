
; size_t ba_priority_queue_size(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_size

EXTERN asm_ba_priority_queue_size

defc ba_priority_queue_size = asm_ba_priority_queue_size
