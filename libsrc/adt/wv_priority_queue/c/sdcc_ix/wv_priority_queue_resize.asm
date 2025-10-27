
; int wv_priority_queue_resize(wv_priority_queue_t *q, size_t n)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_resize

EXTERN _wa_priority_queue_resize

defc _wv_priority_queue_resize = _wa_priority_queue_resize
