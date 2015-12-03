
; void ba_priority_queue_clear(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_clear

EXTERN asm_ba_priority_queue_clear

defc ba_priority_queue_clear = asm_ba_priority_queue_clear
