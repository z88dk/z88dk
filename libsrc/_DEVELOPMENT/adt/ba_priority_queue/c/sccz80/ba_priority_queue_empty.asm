
; int ba_priority_queue_empty(ba_priority_queue_t *q)

SECTION code_adt_ba_priority_queue

PUBLIC ba_priority_queue_empty

defc ba_priority_queue_empty = asm_ba_priority_queue_empty

INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_empty.asm"
