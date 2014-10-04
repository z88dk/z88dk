
; int wv_priority_queue_shrink_to_fit(wv_priority_queue_t *q)

SECTION seg_code_wv_priority_queue

PUBLIC wv_priority_queue_shrink_to_fit

defc wv_priority_queue_shrink_to_fit = asm_wv_priority_queue_shrink_to_fit

INCLUDE "adt/wv_priority_queue/z80/asm_wv_priority_queue_shrink_to_fit.asm"
