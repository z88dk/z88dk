
; size_t ba_priority_queue_size(ba_priority_queue_t *q)

SECTION seg_code_ba_priority_queue

PUBLIC ba_priority_queue_size

defc ba_priority_queue_size = asm_ba_priority_queue_size

INCLUDE "adt/ba_priority_queue/z80/asm_ba_priority_queue_size.asm"
