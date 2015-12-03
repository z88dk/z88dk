
; void wv_priority_queue_destroy(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_destroy

EXTERN asm_wv_priority_queue_destroy

defc wv_priority_queue_destroy = asm_wv_priority_queue_destroy
