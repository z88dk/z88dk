
; void *wv_priority_queue_pop(wv_priority_queue_t *q)

SECTION code_clib
SECTION code_adt_wv_priority_queue

PUBLIC _wv_priority_queue_pop

EXTERN _wa_priority_queue_pop

defc _wv_priority_queue_pop = _wa_priority_queue_pop
