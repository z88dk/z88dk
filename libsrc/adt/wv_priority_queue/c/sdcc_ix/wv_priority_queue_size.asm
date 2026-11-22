
; size_t wv_priority_queue_size(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_size

EXTERN _wa_priority_queue_size

defc _wv_priority_queue_size = _wa_priority_queue_size
