
; int wv_priority_queue_resize(wv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC wv_priority_queue_resize_callee

EXTERN wa_priority_queue_resize_callee

defc wv_priority_queue_resize_callee = wa_priority_queue_resize_callee
