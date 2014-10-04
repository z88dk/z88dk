
; size_t wv_priority_queue_capacity(wv_priority_queue_t *q)

SECTION seg_code_wv_priority_queue

PUBLIC wv_priority_queue_capacity

defc wv_priority_queue_capacity = asm_wv_priority_queue_capacity

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_capacity.asm"
