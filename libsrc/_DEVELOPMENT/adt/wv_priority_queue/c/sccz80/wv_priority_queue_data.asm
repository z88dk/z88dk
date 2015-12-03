
; void *wv_priority_queue_data(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_data

EXTERN asm_wv_priority_queue_data

defc wv_priority_queue_data = asm_wv_priority_queue_data
