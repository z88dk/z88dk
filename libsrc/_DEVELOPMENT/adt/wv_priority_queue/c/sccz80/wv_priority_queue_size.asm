
; size_t wv_priority_queue_size(wv_priority_queue_t *q)

SECTION seg_code_wv_priority_queue

PUBLIC wv_priority_queue_size

defc wv_priority_queue_size = asm_wv_priority_queue_size

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_size.asm"
