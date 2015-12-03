
; void wv_priority_queue_clear(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_clear

EXTERN asm_wv_priority_queue_clear

defc wv_priority_queue_clear = asm_wv_priority_queue_clear
