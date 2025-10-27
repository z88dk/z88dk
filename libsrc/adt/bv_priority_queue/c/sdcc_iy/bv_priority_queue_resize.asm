
; int bv_priority_queue_resize(bv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_bv_priority_queue

PUBLIC _bv_priority_queue_resize

EXTERN _ba_priority_queue_resize

defc _bv_priority_queue_resize = _ba_priority_queue_resize
