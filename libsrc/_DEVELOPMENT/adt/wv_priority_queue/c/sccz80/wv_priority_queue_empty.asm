
; int wv_priority_queue_empty(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_empty

EXTERN asm_wv_priority_queue_empty

defc wv_priority_queue_empty = asm_wv_priority_queue_empty
