
; int ba_priority_queue_pop(ba_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_pop

EXTERN asm_ba_priority_queue_pop

defc ba_priority_queue_pop = asm_ba_priority_queue_pop
