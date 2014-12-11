
; void ba_priority_queue_clear(ba_priority_queue_t *q)

SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_clear

defc ba_priority_queue_clear = asm_ba_priority_queue_clear

INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_clear.asm"
