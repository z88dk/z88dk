
; void *ba_priority_queue_data(ba_priority_queue_t *q)

SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_data

defc ba_priority_queue_data = asm_ba_priority_queue_data

INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_data.asm"
