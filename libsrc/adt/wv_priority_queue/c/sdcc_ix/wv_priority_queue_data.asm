
; void *wv_priority_queue_data(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_data

EXTERN _wa_priority_queue_data

defc _wv_priority_queue_data = _wa_priority_queue_data
