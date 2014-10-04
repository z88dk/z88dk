
; int wv_priority_queue_resize(wv_priority_queue_t *q, size_t n)

SECTION seg_code_wv_priority_queue

PUBLIC wv_priority_queue_resize

EXTERN wa_priority_queue_resize

defc wv_priority_queue_resize = wa_priority_queue_resize
