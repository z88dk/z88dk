
; int bv_priority_queue_resize(bv_priority_queue_t *q, size_t n)

PUBLIC bv_priority_queue_resize

EXTERN ba_priority_queue_resize

;defc bv_priority_queue_resize = ba_priority_queue_resize

bv_priority_queue_resize:

   jp ba_priority_queue_resize
