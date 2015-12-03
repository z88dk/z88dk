
; void *wv_priority_queue_top(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_top

EXTERN asm_wv_priority_queue_top

defc wv_priority_queue_top = asm_wv_priority_queue_top
