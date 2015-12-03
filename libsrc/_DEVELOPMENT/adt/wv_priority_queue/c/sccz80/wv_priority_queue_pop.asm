
; void *wv_priority_queue_pop(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_pop

EXTERN asm_wv_priority_queue_pop

defc wv_priority_queue_pop = asm_wv_priority_queue_pop
