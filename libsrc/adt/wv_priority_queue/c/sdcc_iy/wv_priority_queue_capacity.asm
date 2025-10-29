
; size_t wv_priority_queue_capacity(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_capacity

EXTERN _wa_priority_queue_capacity

defc _wv_priority_queue_capacity = _wa_priority_queue_capacity
