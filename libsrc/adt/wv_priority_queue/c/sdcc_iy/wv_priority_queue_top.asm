
; void *wv_priority_queue_top(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_top

EXTERN _wa_priority_queue_top

defc _wv_priority_queue_top = _wa_priority_queue_top
