
; void wv_priority_queue_clear(wv_priority_queue_t *q)

SECTION seg_code_wv_priority_queue

PUBLIC wv_priority_queue_clear

defc wv_priority_queue_clear = asm_wv_priority_queue_clear

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_clear.asm"
